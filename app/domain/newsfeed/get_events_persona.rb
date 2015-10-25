module Villeme
  module NewsfeedModule
    module Persona
      class << self

        def get_events_persona(personas, city, options = {user: nil, upcoming: true, json: false, limit: nil})
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

        def get_snippet_events(events)
          events[2..12]
        end

        def get_principal_events(events)
          events[0...2]
        end

        def events_persona
          Event.all_persona_in_city(@personas, @city, @options)
        end

        def create_link
          Rails.application.routes.url_helpers.newsfeed_city_persona_path(city: @city, personas: @personas.join('+'))
        end

      end
    end
  end
end