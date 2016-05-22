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
    if params[:categories]
      category_section
    elsif params[:personas]
      persona_section
    else
      newsfeed
    end
  end

  def today
    @resource = params[:resource]
    @city = params[:city]
    @params = 'when=today'
    @feedback = Feedback.new
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

  def agenda
    @user = current_or_guest_user.username
    render :agenda
  end


  private

  def newsfeed
    @resource = 'items'
    @city = params[:city]
    @params = ''
    @feedback = Feedback.new
    render :index
  end

  def category_section
    @resource = 'items'
    @city = params[:city]
    @params = {categories: params[:categories]}.to_query
    @feedback = Feedback.new
    render :section
  end

  def persona_section
    @resource = 'items'
    @city = params[:city]
    @params = {personas: params[:personas]}.to_query
    @feedback = Feedback.new
    render :section
  end

  def set_items_in_map(user, events)
    gon.latitude = user.latitude
    gon.longitude = user.longitude
    gon.events_local_formatted = format_for_map_this(events)
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def get_resource
    if params[:type] == 'Event'
      'events'
    elsif params[:type] == 'Activity'
      'activities'
    else
      'items'
    end
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
