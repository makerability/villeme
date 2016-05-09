module Villeme
  module MountSections
    module Events
      class << self

        def get_events_today(city = false, options = {user: nil, json: false, limit: nil, principal_size: 2, snippet_size: 12, snippet: true})
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

        def get_principal_size
          @options[:principal_size].nil? ? 2 : @options[:principal_size]
        end

        def get_snippet_size
          @options[:snippet_size].nil? ? 12 : @options[:snippet_size]
        end

        def is_snippet?
          @options[:snippet] == nil ? true : @options[:snippet]
        end

        def create_title
          "Eventos acontecendo hoje em #{@city.try(:name)}"
        end

      end
    end
  end
end
