class Api::V1::GeolocationsController < Api::V1::ApiController

  require_relative '../../../domain/usecases/events/get_events_section'
  require_relative '../../../domain/usecases/events/get_activity_section'
  require_relative '../../../domain/newsfeed/get_events_today'

  def all
    city = City.find_by(slug: params[:city])
    section_items = Villeme::UseCases::GetEventsSection.get_all_sections(city, current_or_guest_user, upcoming: true)
    section_activities = Villeme::UseCases::GetActivitiesSection.get_all_sections(city, current_or_guest_user, upcoming: true)
    respond_with format_for_map_this(section_items[:all].concat(section_activities[:all]))
  end

  def today
    city = City.find_by(slug: params[:city])
    section_items = get_item_class.all_today(city)
    respond_with format_for_map_this(section_items)
  end


  private

  def get_item_class(options = {text: false})
    if params[:resource] == 'events'
      Event
    elsif params[:resource] == 'activities'
      Activity
    else
      options[:text] ? 'Item' : Item
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

  def format_for_map_this(events)
    letter = ('A'..'Z').to_a
    i = 0
    @array_of_events = Array.new

    get_events_in_a_hash(events).each do |index, value|
      @array_of_events << {latLng: [value[:latitude].to_s, value[:longitude].to_s],
                           id: letter[i].to_s,
                           data: {link: value[:url].to_s,
                                  name: index.to_s,
                                  address: value[:address]
                           },
                           options: {icon: '/images/marker-default-' + value[:strong_category].to_s.parameterize + '.png'}
      }
      i += 1
    end

    @array_of_events << get_current_user_in_a_hash

    return {
        current_user: {
            latitude: current_or_guest_user.latitude,
            longitude: current_or_guest_user.longitude
        },
        markers: @array_of_events
    }
  end

  def get_events_in_a_hash(events)
    @hash_of_events = Hash.new
    events.each do |event|
      @hash_of_events[event.name] = {
          latitude: event.relative_latitude,
          longitude: event.relative_longitude,
          address: event.address,
          url: "",
          strong_category: strong_category(event, 'slug')
      }
    end
    @hash_of_events
  end


  def get_current_user_in_a_hash
    if current_or_guest_user
      {latLng: current_or_guest_user.try(:coordinates),
       data: current_or_guest_user.try(:name).to_s,
       options: {
           icon: "/images/marker-user.png"
       }
      }
    else
      {}
    end
  end

  def strong_category(event, type)
    # contador para retornar o mais forte se existir mais de uma categoria
    i = event.categories.count

    case type
      when 'slug'
        return categories_slug(event, i)
      when 'item'
        return categories_item(event, i)
    end

  end


  def categories_item(event, i)
    if event.categories.empty?
      return nil
    else
      event.categories[0, 2].each do |category|
        if i == 1
          return "<a href='#{url_for(newsfeed_category_path(category))}'><span class='item #{category.try(:slug)}'>#{category.name}</span></a>".html_safe
        elsif category.name != 'Lazer'
          return "<a href='#{url_for(newsfeed_category_path(category))}'><span class='item #{category.try(:slug)}'>#{category.name}</span></a>".html_safe
        end
      end
    end
  end


  def categories_slug(event, i)
    event_categories = event.categories.includes(:translations)
    if event_categories.empty?
      "leisure"
    else
      event_categories[0, 2].each do |category|
        if i == 1
          return category.slug
        elsif category.slug != 'leisure'
          return category.slug
        end
      end
    end
  end


end
