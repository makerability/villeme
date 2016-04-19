class NewsfeedController < ApplicationController

  # verifica se o user esta logado
  before_action :is_logged, except: [:index, :city]

  # verifica se a conta esta completa
  before_action :is_invited

  # verifica se a conta esta completa
  before_action :is_complete, except: [:index, :city]


  include Gmaps


  # =Newsfeed Layout
  layout 'fullwidth_layout'


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
    @feedback = Feedback.new
    render :index
  end

  def today
    @city = City.find_by(slug: params[:city])
    @items = get_item_class.all_today(@city)
    @items_json = Item.items_to_json(@items, user: current_or_guest_user).as_json
    @title = "#{get_items_name} acontecendo hoje em #{@city.name}"
    set_items_in_map(current_or_guest_user, @items)
    @city_ = params[:city]
    @type_ = "today"
    render :section
  end

  def persona
    @city = City.find_by(slug: params[:city])
    personas = Persona.query_to_array(params[:personas])
    @items = Event.all_persona_in_city(personas, @city)
    @items_json = Item.items_to_json(@items, user: current_or_guest_user).as_json
    @title = "Eventos indicados para você em #{@city.name}"
    set_items_in_map(current_or_guest_user, @items)
    render :section
  end

  def neighborhood
    @neighborhood = Neighborhood.find_by(slug: params[:neighborhood])
    @items = Event.all_in_neighborhood(@neighborhood)
    @items_json = Item.items_to_json(@items, user: current_or_guest_user).as_json
    @title = "Eventos no bairro #{@neighborhood.name}"
    set_items_in_map(current_or_guest_user, @items)
    render :section
  end

  def category
    @city = City.find_by(slug: params[:city])
    categories = Category.query_to_array(params[:categories])
    @items = Item.all_categories_in_city(categories, @city)
    @items_json = Item.items_to_json(@items, user: current_or_guest_user).as_json
    @title = "Eventos nas categorias #{params[:categories]}"
    set_items_in_map(current_or_guest_user, @items)
    render :section
  end

  def agenda
    @items = current_user.agenda_items.upcoming
    @items_json = Event.items_to_json(@items, user: current_or_guest_user).as_json
    @title = "Minha agenda de Eventos e Atividades"
    set_items_in_map(current_user, @items)
    render :section
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

  def get_item_class(options = {text: false})
    if params[:type] != nil
      options[:text] ? params[:type] : params[:type].constantize
    elsif @item and @item.type != nil
      options[:text] ? @item.type : @item.type.constantize
    else
      options[:text] ? 'Item' : 'Item'.constantize
    end
  end

  def get_items_name
    if params[:type] != nil
      case params[:type]
        when 'Event' then 'Eventos'
        when 'Activity' then 'Atividades'
        else 'Items'
      end
    else
      'Items'
    end
  end

end
