# encoding: utf-8
class Item < ActiveRecord::Base

  require_relative '../domain/usecases/events/event_attributes'
  require_relative '../domain/usecases/geolocalization/get_geocoder_attributes'
  require_relative '../domain/usecases/geolocalization/geocode_event'
  require_relative '../domain/json/item/item_to_json'
  require_relative '../domain/items/get_items_section'

  after_validation :geocode_event, unless: 'address.nil?'

  ratyrate_rateable "geral"

  extend FriendlyId
  friendly_id :name, use: :slugged

  include GeocodedActions


  # Associações
  belongs_to :place
  belongs_to :user
  belongs_to :price
  has_and_belongs_to_many :personas
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :subcategories
  has_and_belongs_to_many :weeks

  has_many :agendas
  has_many :agended_by, through: :agendas, source: :user

  has_many :tips

  # Avisa a classe que possui imagem no POST
  has_attached_file :image

  accepts_nested_attributes_for :place


  # gem paperclip
  has_attached_file :image,
                    styles: {thumb: "60x50#",
                             medium: "280x280#",
                             large: "690x280#",
                             share: "484x252#"},
                    default_url: "/images/:style/missing.png"



  validates :name, presence: true, uniqueness: true, length: 6..140
  validates :description, allow_blank: true, length: 10..5000
  validates :address, presence: true, length: {maximum: 200}, unless: Proc.new {|event| Place.find_by(name: event.address).nil?}
  validates :hour_start_first, presence: true, if: 'allday.nil?'
  validates :date_start, presence: true, if: 'all_year.nil?'
  validates :cost, length: {maximum: 8}
  validates :cost_details, length: {maximum: 300}
  validates :email, allow_blank: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  validates :link, length: {maximum: 300}
  validates :phone, length: {maximum: 20}
  # validates_attachment_presence :image
  # validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/


  # SCOPES

  scope :upcoming, lambda {
    where('all_year = ? OR date_start >= ? AND date_finish >= ? AND moderate = 1 OR date_start <= ? AND date_finish >= ? AND moderate = 1', true, Date.current - 30, Date.current, Date.current, Date.current).order(:date_start)
  }


  def self.to_json(item, options = {user: nil})
    Villeme::JSONModule.item_to_json(item, options)
  end

  def self.all_today(options = {city: false, type: false, limit: false})
    Villeme::ItemsSection.all_today(options)
  end

  def self.all_persona_in_city(personas, city, options = {limit: false, user: nil, upcoming: true, json: false})
    Villeme::ItemsSection.all_persona_in_city(personas, city, options)
  end

  def self.all_categories_in_city(categories, city, options = {user: nil, slug: false, upcoming: true, json: false, limit: false})
    Villeme::ItemsSection.all_categories_in_city(categories, city, options)
  end

  def self.all_in_neighborhood(neighborhood, options = {user: nil, upcoming: true, json: false, limit: false})
    Villeme::ItemsSection.all_in_neighborhood(neighborhood, options)
  end

  def self.all_fun_in_city(city, options = {user: nil, upcoming: true, json: false, limit: false})
    Villeme::ItemsSection.all_fun_in_city(city, options)
  end

  def self.all_education_in_city(city, limit = false)
    Villeme::ItemsSection.all_education_in_city(city, limit)
  end

  def self.all_health_in_city(city, limit = false)
    Villeme::ItemsSection.all_health_in_city(city, limit)
  end

  def self.all_trends_in_city(city, options = {user: nil, upcoming: nil, json: false, slug: true, limit: nil})
    Villeme::ItemsSection.all_trends_in_city(city, options)
  end

  def self.items_to_json(items, options = {user: nil})
    if items.empty?
      return Item.none
    else
      response = []
      items.each { |item| response << Item.to_json(item, user: options[:user]) }
      return response
    end
  end

  def agended?(user)
    if user.nil?
      false
    elsif user.items_agenda.include?(self)
      true
    else
      false
    end
  end

  def name_with_limit
    Villeme::UseCases::EventAttributes.name_with_limit(self)
  end

  def description_with_limit
    Villeme::UseCases::EventAttributes.description_with_limit(self)
  end

  def description_without_html
    Villeme::UseCases::EventAttributes.description_without_html(self)
  end

  def relative_latitude
    Villeme::UseCases::GeocoderAttributes.relative_latitude(self)
  end

  def relative_longitude
    Villeme::UseCases::GeocoderAttributes.relative_longitude(self)
  end

  def price
    Villeme::UseCases::EventAttributes.price(self)
  end

  def agended_by_count
    number = self.agended_by.count
    if number == 0
      response = {valid: false, count: ""}
    elsif number == 1
      response = {valid: true, count: 1, text: '1 pessoa agendou'}
    else
      response = {valid: true, count: number, text: "#{number} pessoas agendaram"}
    end

    response
  end


  def period_that_occurs
    Villeme::UseCases::EventAttributes.period_that_occurs(self)
  end


  # Retorna o dia da semana que o evento acontece

  def day_of_week
    require_relative '../../app/domain/usecases/weeks/get_day_of_week'
    require_relative '../../app/domain/usecases/dates/get_next_day_occur_human_readable'
    Villeme::UseCases::Dates.new(self).get_next_day_occur_human_readable
  rescue
    nil
  end

  def today?
    require_relative '../../app/domain/usecases/dates/get_next_day_occur_human_readable'
    Villeme::UseCases::Dates.new(self).today?
  end

  def start_hour
    require_relative '../domain/usecases/events/event_attributes'
    Villeme::UseCases::EventAttributes.get_start_hour(self)
  end

  # Retorna os dias da semana que o evento acontece
  def days_of_week

    # array para retorno
    days_of_event = Array.new

    # pega os dias da semana do evento
    week_of_event = self.weeks.select([:id, :name, :slug])
    week = Week.select([:id, :name, :slug]).includes(:translations)

    # compara os dias do evento com o de uma semana comum
    week.each do |day|
      if week_of_event.include? day
        days_of_event << "<span class='label white-bg border'>#{day.name}</span>"
      else
        days_of_event << "<span class='label white-bg border has-tooltip' title='Neste dia o evento não ocorre'><s>#{day.name}</s></span>"
      end
    end

    return "#{days_of_event.join(' ')}".html_safe
  end

  def rates_media
    rates = Rate.where(rateable_id: id)
    if rates.empty?
      nil
    else
      '%.1f' % rates.average(:stars)
    end
  end

  def rates_count
    rates = Rate.where(rateable_id: self.id)

    if rates.empty?
      "Seja o primeiro a avaliar"
    else
      "#{rates.count}"
    end
  end

  def rates_cache
    Rate.where(rateable_id: self.id).empty? ? nil : Rate.where(rateable_id: self.id).maximum(:updated_at).try(:utc).try(:to_s, :number)
  end

  def geocode_event
    Villeme::UseCases::GeocodeEvent.new(self).geocoded_by_address(self.address)
  end

end
