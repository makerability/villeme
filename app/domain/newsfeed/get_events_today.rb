module Villeme
  module NewsfeedModule
    class << self

      def get_events_today(city = false, options = {user: nil, json: false, limit: nil})
        @city = city
        @options = options

        create_json(events_today)
      end


      private

      def events_today
        Event.all_today(@city, @options)
      end

      def create_json(events)
        {
            title: create_title,
            items: get_principal_events(events),
            snippet: get_snippet_events(events),
            count: events.count,
            link: create_link,
            link_to_create: '/events/new',
            city_name: @city.name,
            type: 'today'
        }
      end

      def create_link
        Rails.application.routes.url_helpers.newsfeed_city_today_path(city: @city, type: 'Event')
      end

      def get_snippet_events(events)
        events[2...12]
      end

      def get_principal_events(events_all_today)
        events_all_today[0...2]
      end

      def create_title
        "Eventos acontecendo hoje em #{@city.try(:name)}"
      end

    end
  end
end