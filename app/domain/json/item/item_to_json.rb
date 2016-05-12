module Villeme
  module JSONModule
    class << self

      def item_to_json(item, options)
        @item = item
        @options = options
        @user = options[:user]

        @distance = calculate_distance_from_user_to_item
        @params = define_action_name_to_url

        create_json
      end


      private

      def create_json
        {
            id: @item.slug,
            name: @item.name,
            description: @item.description_with_limit,
            latitude: get_item_latitude,
            longitude: get_item_longitude,
            full_address: @item.full_address,
            link: create_link,
            subcategories: @item.subcategories.try(:first).try(:name),
            day_of_week: @item.day_of_week,
            period_that_occurs: @item.period_that_occurs,
            start_hour: @item.start_hour,
            image: create_image_json,
            price: @item.price,
            rating: @item.rates_media,
            friends: create_friends_json,
            distance: create_distance_json,
            agended_by: create_agenda_json,
            place: create_place_json,
            actions: create_actions_json,
            is_agended: @item.agended?(@user),
            all_day: @item.allday,
            all_year: @item.all_year
        }
      end

      def create_image_json
        {
            thumb: @item.image.url(:thumb),
            medium: @item.image.url(:medium),
            large: @item.image.url(:large)
        }
      end

      def create_link
        "/#{@params}/#{@item.slug}"
      end

      def get_item_longitude
        @item.longitude.blank? ? @item.place.longitude : @item.longitude
      end

      def get_item_latitude
        @item.latitude.blank? ? @item.place.latitude : @item.latitude
      end

      def create_actions_json
        {
            schedule: "/items/#{@item.try(:slug)}/schedule",
        }
      end

      def create_place_json
        {
            name: @item.place.try(:name),
            link: "/places/#{@item.place.slug}"
        }
      end

      def create_agenda_json
        {
            count: @item.agended_by_count[:count],
            text: @item.agended_by_count[:text]
        }
      end

      def create_friends_json
        {
            someone_will: !@user.which_friends_will_this_event?(@item).blank?,
            will: @user.which_friends_will_this_event?(@item, json: true)
        }
      end

      def create_distance_json
        {
            bus: get_bus_distance,
            car: get_car_distance,
            walk: get_walk_distance,
            bike: get_bike_distance,
        }
      end

      def get_bike_distance
        @distance ? "#{@distance[:bike]}min." : nil
      end

      def get_walk_distance
        @distance ? "#{@distance[:walk]}" : nil
      end

      def get_car_distance
        @distance ? "#{@distance[:car]}min." : nil
      end

      def get_bus_distance
        @distance ? "#{@distance[:bus]}min." : nil
      end

      def define_action_name_to_url
        case @item.type
          when 'Event'
            return 'events'
          when 'Activity'
            return 'activities'
          else
            return 'items'
        end
      end

      def calculate_distance_from_user_to_item
        if @user.guest?
          false
        else
          @user.distance_until(@item, :minutes)
        end
      end

    end
  end
end
