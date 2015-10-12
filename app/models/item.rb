# encoding: utf-8
class Item < ActiveRecord::Base

	require_relative '../domain/usecases/events/event_attributes'
	require_relative '../domain/usecases/geolocalization/get_geocoder_attributes'
	require_relative '../domain/usecases/geolocalization/geocode_event'

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
                    styles: {thumb: "60x50>",
														 medium: "280x280>",
														 large: "690x280>",
														 share: "484x252>"},
                    default_url: "/images/:style/missing.png"



	validates :name, presence: true, uniqueness: true, length: 6..140
	validates :description, allow_blank: true, length: 10..5000
	validates :address, presence: true, length: {maximum: 200}, unless: Proc.new {|event| Place.find_by(name: event.address).nil?}
	validates :hour_start_first, presence: true, if: 'allday.nil?'
	validates :date_start, presence: true
	validates :cost, length: {maximum: 8}
	validates :cost_details, length: {maximum: 300}
	validates :email, allow_blank: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
	validates :link, length: {maximum: 300}
	validates :phone, length: {maximum: 20}
	validates_attachment_presence :image
	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/


	# SCOPES

	scope :upcoming, lambda {
	  where('date_start >= ? AND date_finish >= ? AND moderate = 1 OR date_start <= ? AND date_finish >= ? AND moderate = 1', Date.current - 30, Date.current, Date.current, Date.current).order(:date_start)
	}
	scope :upcoming_by_persona, lambda { |user|
		where('date_start >= ? AND date_finish >= ? AND moderate = 1 OR date_start <= ? AND date_finish >= ? AND moderate = 1', Date.current - 30, Date.current, Date.current, Date.current).order("CASE WHEN persona_id IS NULL THEN 1 ELSE 0 END, persona_id = #{user.try(:persona_id)} DESC, date_start ASC")
	}

	def self.to_json(item, options = {user: nil})
		unless options[:user].guest?
			distance = options[:user].distance_until(item, :minutes)
		end
		action = case item.type
							 when 'Event' then 'events'
							 when 'Activity' then 'activities'
							 else 'items'
						 end
		{
				id: item.slug,
				name: item.name,
				description: item.description_with_limit,
				latitude: item.latitude.blank? ? item.place.latitude : item.latitude,
				longitude: item.longitude.blank? ? item.place.longitude : item.longitude,
				full_address: item.full_address,
				link: "/#{action}/#{item.slug}",
				subcategories: item.subcategories.try(:first).try(:name),
				day_of_week: item.day_of_week,
				period_that_occurs: item.period_that_occurs,
				start_hour: item.start_hour,
				image: {
						thumb: item.image.url(:thumb),
						medium: item.image.url(:medium),
						large: item.image.url(:large)
				},
				price: {
						value: item.price[:value],
						highlight: item.price[:css_attributes]
				},
				rating: item.rates_media,
				distance: {
						bus: distance ? "#{distance[:bus]}min." : nil ,
						car: distance ? "#{distance[:car]}min." : nil,
						walk: distance ? "#{distance[:walk]}" : nil,
						bike: distance ? "#{distance[:bike]}min." : nil,
				},
				agended_by: {
						count: item.agended_by_count[:count],
						text: item.agended_by_count[:text]
				},
				place: {
						name: item.place.try(:name),
						link: "/places/#{item.place.id}"
				},
				actions: {
						schedule: "/items/#{item.try(:slug)}/schedule",
				},
				is_agended: item.agended?(options[:user])

		}
	end

	def self.all_today(options = {city: false, type: false, limit: false})
		response = []

		events = if options[:city]
							 options[:city].items.includes(:weeks, :agendas, :place, :subcategories)
						 else
							 self.all.includes(:weeks, :agendas, :place, :subcategories)
						 end

		events.each do |event|
			if event.today?
				response << event
			end
		end

		return response
	end

	def self.all_persona_in_city(personas, city, options = {limit: false, user: nil, upcoming: true, json: false})
		if options[:limit] and city.try(:items)
			city.items.includes(:personas).where(personas: { name: personas }).limit(options[:limit])
		elsif city.try(:items)
			items = if options[:upcoming]
								city.items.includes(:personas).where(personas: {name: personas}).upcoming
							else
								city.items.includes(:personas).where(personas: {name: personas})
							end

			if options[:json]
				return items_to_json(items, options)
			else
				return items
			end
		else
			Item.none
		end
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

	def self.all_categories_in_city(categories, city, options = {user: nil, slug: false, upcoming: true, json: false, limit: false})
		name_or_slug_key = options[:slug] ? { slug: categories } : { name: categories }

		items = if options[:limit] and city.try(:items)
							if options[:upcoming]
								city.items.includes(:categories).where(categories: name_or_slug_key).limit(options[:limit]).upcoming
							else
								city.items.includes(:categories).where(categories: name_or_slug_key).limit(options[:limit])
							end
						elsif city.try(:items)
							if options[:upcoming]
								city.items.includes(:categories).where(categories: name_or_slug_key).upcoming
							else
								city.items.includes(:categories).where(categories: name_or_slug_key)
							end
						else
							Item.none
						end

		if options[:json]
			return items_to_json(items, options)
		else
			return items
		end
	end

	def self.all_in_neighborhood(neighborhood, options = {user: nil, upcoming: true, json: false, limit: false})
		items = if options[:limit] and neighborhood.try(:events)
							if options[:upcoming]
								neighborhood.events.limit(options[:limit]).upcoming
							else
								neighborhood.events.limit(options[:limit])
							end
						elsif neighborhood.try(:events)
							if options[:upcoming]
								neighborhood.events.upcoming
							else
								neighborhood.events
							end
						else
							Event.none
						end

		if options[:json]
			return items_to_json(items, options)
		else
			return items
		end
	end

	def self.all_fun_in_city(city, options = {user: nil, upcoming: true, json: false, limit: false})
		items = if options[:limit]
							if options[:upcoming]
								city.events.includes(:categories).where(categories: { slug: Newsfeed.configs[:sections][:fun]}).limit(options[:limit]).upcoming
							else
								city.events.includes(:categories).where(categories: { slug: Newsfeed.configs[:sections][:fun]}).limit(options[:limit])
							end
						else
							if options[:upcoming]
								city.events.includes(:categories).where(categories: { slug: Newsfeed.configs[:sections][:fun]}).upcoming
							else
								city.events.includes(:categories).where(categories: { slug: Newsfeed.configs[:sections][:fun]})
							end
						end

		if options[:json]
			return items_to_json(items, options)
		else
			return items
		end
	end

	def self.all_education_in_city(city, limit: false)
		if limit
			city.events.includes(:categories).where(categories: { slug: Newsfeed.configs[:sections][:education]}).limit(limit)
		else
			city.events.includes(:categories).where(categories: { slug: Newsfeed.configs[:sections][:education] })
		end
	end

	def self.all_health_in_city(city, limit: false)
		if limit
			city.events.includes(:categories).where(categories: { slug: Newsfeed.configs[:sections][:health]}).limit(limit)
		else
			city.events.includes(:categories).where(categories: { slug: Newsfeed.configs[:sections][:health] })
		end
	end

	def self.all_trends_in_city(city, options = {user: nil, upcoming: nil, json: false, slug: true, limit: nil})
		if options[:limit]
			city.events.where('agendas_count > 1').order('agendas_count DESC').limit(options[:limit])
		else
			city.events.where('agendas_count > 1').order('agendas_count DESC')
		end
	end

	def agended?(user)
		if user.nil?
			false
		elsif user.agenda_items.include?(self)
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
			respota = {valid: false, count: ""}
		elsif number == 1
			respota = {valid: true, count: 1, text: '1 pessoa agendou'}
		else
			respota = {valid: true, count: number, text: "#{number} pessoas agendaram"}
		end

		respota
	end


	def period_that_occurs
    Villeme::UseCases::EventAttributes.period_that_occurs(self)
	end


	# Retorna o dia da semana que o evento acontece

	def day_of_week(options = {})
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
