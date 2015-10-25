module Villeme
  module NewsfeedModule
    class << self

      def get_events_neighborhood(neighborhood, options = {user: nil, upcoming: true, json: false, limit: nil})
        @neighborhood = neighborhood
        @options = options

        create_json(events_neighborhood)
      end


      private

      def create_json(events)
        {
            title: create_title,
            items: get_principal_events(events),
            snippet: get_snippet_events(events),
            count: events.count,
            link: create_link,
            link_to_create: '/events/new',
            neighborhood_name: @neighborhood.name,
            type: '@neighborhood'
        }
      end

      def events_neighborhood
        Event.all_in_neighborhood(@neighborhood, @options)
      end

      def create_title
        "Eventos acontecendo no bairro #{@neighborhood.name}"
      end

      def get_principal_events(events)
        events[0...2]
      end

      def get_snippet_events(events)
        events[2...12]
      end

      def create_link
        Rails.application.routes.url_helpers.newsfeed_city_neighborhood_path(city: @neighborhood.city, neighborhood: @neighborhood)
      end

    end
  end
end