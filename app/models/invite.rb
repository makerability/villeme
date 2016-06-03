class Invite < ActiveRecord::Base

  require_relative '../../app/domain/usecases/geolocalization/geocode_invite'
  include GeocodedActions

  belongs_to :user
  has_and_belongs_to_many :personas

  validates :name, presence: true, length: 1..140
  validates :email, presence: true, length: 6..140

  after_validation :geocode_invite, unless: 'address.nil?'
  after_validation :create_key_and_password

  private

  def geocode_invite
    Villeme::UseCases::GeocodeInvite.new(self).geocoded_by_address(self.address)
  end

  def create_key_and_password
    require 'securerandom'
    self.key = SecureRandom.urlsafe_base64
    self.password = Devise.friendly_token[0, 8]
  end

end
