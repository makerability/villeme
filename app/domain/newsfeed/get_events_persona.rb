module Villeme
  module NewsfeedModule
    class << self

      def get_events_persona(personas, city, options = {user: nil, upcoming: true, json: false, limit: nil, principal_size: 2, snippet_size: 12, snippet: true})
        @personas = personas
        @city = city
        @options = options


        create_json(events_persona)
      end


      private

      def create_json(events)
        {
            title: 'Eventos indicados para você',
            items: get_principal_events(events),
            snippet: get_snippet_events(events),
            count: events.count,
            link: create_link,
            link_to_create: '/events/new',
            type: 'persona'
        }
      end

      def get_principal_events(events)
        if is_snippet?
          events[0...get_principal_size]
        else
          events
        end
      end

      def get_snippet_events(events)
        if is_snippet?
          events[get_principal_size..get_snippet_size]
        else
          Event.none
        end
      end

      def events_persona
        Event.all_persona_in_city(@personas, @city, @options)
      end

      def create_link
        if @city and @personas
          Rails.application.routes.url_helpers.newsfeed_city_persona_path(
              city: @city,
              personas: @personas
          )
        else
          nil
        end
      end

      def get_principal_size
        @options[:principal_size].nil? ? 2 : @options[:principal_size]
      end

      def get_snippet_size
        @options[:snippet_size].nil? ? 12 : @options[:snippet_size]
      end

      def is_snippet?
        @options[:snippet] == nil ? true : @options[:snippet]
      end

    end
  end
end
