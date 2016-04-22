module Villeme
  module NewsfeedModule
    module Events
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
          if @city
            Rails.application.routes.url_helpers.newsfeed_city_today_path(
                city: @city,
                resource: 'events'
              )
          else
            nil
          end
        end

        def get_principal_events(events)
          events.count <= 2 ? events[0...2] : events[0...5]
        end

        def get_snippet_events(events)
          events.count <= 2 ? events[2...12] : events[5...15]
        end

        def create_title
          "Eventos acontecendo hoje em #{@city.try(:name)}"
        end

      end
    end
  end
end
