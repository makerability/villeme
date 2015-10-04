class NewsfeedController < ApplicationController

  # verifica se o user esta logado
  before_action :is_logged, except: [:index, :city]

  # verifica se a conta esta completa
  before_action :is_invited

  # verifica se a conta esta completa
  before_action :is_complete, except: [:index, :city]

  include Gmaps



  # Layout newsfeed
  layout 'full-width'


  def index
    if current_or_guest_user.nil?
      redirect_to welcome_path
    elsif current_or_guest_user.city_slug
      redirect_to newsfeed_city_path(current_or_guest_user.city_slug) and return
    else
      redirect_to newsfeed_city_path(City.where(launch: true).first.slug) and return
    end

  end

  def city
    if current_or_guest_user.guest?
      render_newsfeed_for_guest_user
    elsif params[:city]
      require_relative '../../app/domain/usecases/events/get_event_section'
      require_relative '../../app/domain/usecases/events/get_activity_section'

      @city = City.find_by(slug: params[:city])
      @items = Villeme::UseCases::GetEventsSection.get_all_sections(@city, current_or_guest_user)
      @activities = Villeme::UseCases::GetActivitiesSection.get_all_sections(@city, current_or_guest_user)
      @number_of_events = @items[:all].count
      @message_for_none_events = "Não há eventos no momento em #{@city.name}."
      @feedback = Feedback.new

      # user location
      gon.latitude = current_or_guest_user.latitude
      gon.longitude = current_or_guest_user.longitude

      # array with places for map navigator on sidebar
      gon.events_local_formatted = format_for_map_this(@items[:all])

      render :index
    end
  end

  def today
    @city = City.find_by(slug: params[:city])
    @items = get_item_class.all_today(city: @city)
    @text = "Acontecendo hoje em #{@city.name}"
    set_items_in_map(current_or_guest_user, @items)
    render :section, layout: 'main_and_right_sidebar'
  end

  def persona
    @city = City.find_by(slug: params[:city])
    personas = Persona.query_to_array(params[:personas])
    @items = Event.all_persona_in_city(personas, @city).upcoming
    @text = "Eventos indicados para você"
    set_items_in_map(current_or_guest_user, @items)
    render :section, layout: 'main_and_right_sidebar'
  end

  def neighborhood
    @neighborhood = Neighborhood.find_by(slug: params[:neighborhood])
    @items = Event.all_in_neighborhood(@neighborhood).upcoming
    @text = "Eventos no bairro #{@neighborhood.name}"
    set_items_in_map(current_or_guest_user, @items)
    render :section, layout: 'main_and_right_sidebar'
  end

  def category
    @city = City.find_by(slug: params[:city])
    categories = Category.query_to_array(params[:categories])
    @items = Event.all_categories_in_city(categories, @city).upcoming
    set_items_in_map(current_or_guest_user, @items)
    render :section, layout: 'main_and_right_sidebar'
  end

  def agenda
    @items = current_user.agenda_items.upcoming
    set_items_in_map(current_user, @items)
    render :section, layout: 'main_and_right_sidebar'
  end


  private

  def set_items_in_map(user, events)
    gon.latitude = user.latitude
    gon.longitude = user.longitude
    gon.events_local_formatted = format_for_map_this(events)
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def render_newsfeed_for_guest_user
    require_relative '../../app/domain/usecases/events/get_event_section'
    require_relative '../../app/domain/usecases/events/get_activity_section'

    @city = City.find_by(slug: params[:city])
    @items = Villeme::UseCases::GetEventsSection.get_all_sections(@city, current_or_guest_user)
    @activities = Villeme::UseCases::GetActivitiesSection.get_all_sections(@city, current_or_guest_user)
    @number_of_events = @items[:all].count
    @message_for_none_events = "Não há eventos no momento em #{@city.name}."
    @feedback = Feedback.new

    # user location
    gon.latitude = current_or_guest_user.latitude
    gon.longitude = current_or_guest_user.longitude

    # array with places for map navigator on sidebar
    gon.events_local_formatted = format_for_map_this(@items[:all])

    render :index
  end


  def get_item_class(options = {text: false})
    if params[:type] != nil
      options[:text] ? params[:type] : params[:type].constantize
    elsif @item and @item.type != nil
      options[:text] ? @item.type : @item.type.constantize
    else
      options[:text] ? 'Item' : 'Item'.constantize
    end
  end


end
