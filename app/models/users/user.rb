class User < ActiveRecord::Base


  # =User Dependencies
  require_relative '../../domain/usecases/events/get_events'
  require_relative '../../repositories/friends/friends_from_facebook_on_villeme'
  require_relative '../../repositories/friends/friends_from_facebook'
  require_relative '../../services/friends/ranking_friends'
  require_relative '../../domain/agenda/agenda_module'
  require_relative '../../domain/notifies/notifies_modules'
  require_relative '../../domain/usecases/cities/get_city_slug'
  require_relative '../../domain/usecases/geolocalization/geocode_user'
  require_relative '../../services/account/is_account_complete'
  require_relative '../../domain/avatar/avatar_module'
  require_relative '../../domain/levels/levels_module'

  # =Facebook oauth
  extend FacebookOauth

  # =Geocoder
  include GeocodedActions

  # =Gamification
  has_merit

  # =Rating
  ratyrate_rater

  # =Urls personalized
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  def slug_candidates
    [
        :name,
        [:name, :id]
    ]
  end

  # =Devise
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable, :omniauth_providers => [:facebook]

  # =Paperclip
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>", :avatar => "38x38" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/



  # =Validations
  def password_required?
    if guest?
      false
    else
      !persisted? || !password.nil? || !password_confirmation.nil?
    end
  end

  def email_required?
    if guest?
      false
    else
      true
    end
  end

  after_validation :geocode_user, unless: 'address.nil?' or :guest?


  # =User Associations
  belongs_to :level
    delegate :name, to: :level, prefix: true, allow_nil: true
    delegate :nivel, to: :level, prefix: true, allow_nil: true
  has_and_belongs_to_many :personas
    delegate :name, to: :persona, prefix: true, allow_nil: true
  has_one :notify
  has_many :places
  has_many :items
  has_many :events
  has_many :feedbacks
  has_many :tips
  has_many :agendas, class_name: 'Agenda'
  has_many :items_agenda,
           -> { uniq },
           through: :agendas,
           source: :item,
           foreign_key: :agenda_id
  has_many :friendships
  has_many :friends, through: :friendships
  has_many :accepted_friendships,
          -> { where confirmed: true },
          class_name: 'Friendship'
  has_many :accepted_friends,
          through: :accepted_friendships,
          source: :friend,
          foreign_key: :friend_id
  has_many :requested_friendships,
          -> { where status: 'requested', confirmed: false},
          class_name: 'Friendship'
  has_many :requested_friends,
          through: :requested_friendships,
          source: :friend,
          foreign_key: :friend_id
  has_many :pending_friendships,
          -> { where status: 'pending', confirmed: false },
          class_name: 'Friendship'
  has_many :pending_friends,
          through: :pending_friendships,
          source: :friend,
          foreign_key: :friend_id


  # =User Actions
  def first_name
    name ? name.split.first : nil
  end

  def persona
    Persona.get_user_personas(self)
  end

  def personas_name
    Persona.get_names(self.personas)
  end

  def personas_query
    Persona.to_query(self.personas)
  end

  def city_slug
    Villeme::UseCases::GetCitySlug.from_user(self)
  end

  def events_from_neighborhood
    Villeme::UseCases::GetEvents.from_neighborhood(self)
  end

  def quantity_of_events_from_neighborhood
    Villeme::UseCases::GetEvents.quantity_from_neighborhood(self)
  end

  def my_neighborhood_has_events?
    Villeme::UseCases::GetEvents.neighborhood_has_events?(self)
  end

  def events_from_persona
    Villeme::UseCases::GetEvents.from_persona(self)
  end

  def quantity_of_events_from_persona
    Villeme::UseCases::GetEvents.quantity_of_events_from_persona(self)
  end

  def level_icon_url
    Villeme::LevelsModule.get_icon(self)
  end

  def next_level
    Villeme::LevelsModule.next_level(self)
  end

  def points_to_next_level
    Villeme::LevelsModule.points_to_next_level(self)
  end

  def percentage_of_current_level
    Villeme::LevelsModule.percentage_of_current_level(self)
  end

  def account_complete?
    AccountService.is_account_complete?(self)
  end

  def get_avatar_url
    Villeme::AvatarModule.get_avatar_url(self)
  end

  def get_avatar_origin
    Villeme::AvatarModule.get_avatar_origin(self)
  end

  def agended?(event)
    self.items_agenda.include?(event) ? true : false
  end

  def schedule(item)
    self.agendas << Agenda.new(user: self, item: item)
  end

  def unschedule(item)
    self.agendas.find_by_user_id_and_item_id(self, item).destroy
  end

  def are_friends?(friend)
    self.accepted_friends.exists?(friend)
  end

  def are_friedship_invite?(friend)
    self.pending_friends.exists?(friend)
  end

  def facebook_friends
    FriendsRepository.get_friends_from_facebook(self)
  end

  def facebook_friends_on_villeme
    FriendsRepository.facebook_friends_on_villeme(self)
  end

  def ranking_of_friends
    FriendsService.ranking_friends(self)
  end

  def which_friends_will_this_event?(event, options = {})
    Villeme::AgendaModule.which_friends_will_this_event?(self, event, options)
  end

  def requested_friendships_notifies
    Villeme::NotifiesModules.requested_friendships_notifies(self)
  end

  def newsfeed_notify
    Villeme::NotifiesModules.get_notifies(self)
  end

  def newsfeed_notify_count
    Villeme::NotifiesModules.newsfeed_notify_count(self)
  end

  def has_notify
    Villeme::NotifiesModules.has_notify(self)
  end

  def geocode_user
    Villeme::UseCases::GeocodeUser.new(self).geocoded_by_address(self.address)
  end

end
