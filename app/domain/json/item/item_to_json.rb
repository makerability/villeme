module Villeme
  module JSON
    class << self

      def item_to_json(item, options)
        distance = calculate_distance_from_user_to_item(item, options)
        action = define_action_name_to_url(item)
        user = options[:user]

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
            friends: {
              someone_will?: !user.which_friends_will_this_event?(item).blank?,
              will: user.which_friends_will_this_event?(item, json: true)
            },
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
            is_agended: item.agended?(user)
        }
      end

      def define_action_name_to_url(item)
        case item.type
          when 'Event'
            return 'events'
          when 'Activity'
            return 'activities'
          else
            return 'items'
        end
      end

      def calculate_distance_from_user_to_item(item, options)
        if options[:user].guest?
          false
        else
          options[:user].distance_until(item, :minutes)
        end
      end

    end
  end
end