module Villeme
  module MountSections
    module Neighborhood
      class << self

        def get_events_neighborhood(neighborhoods, options = {user: nil, upcoming: true, json: false, limit: nil})
          @neighborhoods = neighborhoods
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
              neighborhood_name: @neighborhoods,
              type: 'neighborhood'
          }
        end

        def events_neighborhood
          Event.all_in_neighborhood(@neighborhoods, @options)
        end

        def create_title
          "Eventos acontecendo no bairro #{get_neighborhoods_name}"
        end

        def get_principal_events(events)
          events[0...2]
        end

        def get_snippet_events(events)
          events[2...12]
        end

        def create_link
          if @neighborhoods
            if @neighborhoods.is_a? Array
              "?#{{neighborhoods: @neighborhoods.map(&:capitalize)}.to_query}"
            else
              "?#{{neighborhoods: @neighborhoods}.to_query}"
            end
          else
            nil
          end
        end

        def get_neighborhoods_name
          if @neighborhoods.is_a? Array
            @neighborhoods.map(&:capitalize).join(" e ")
          else
            @neighborhoods.capitalize
          end
        end

      end
    end
  end
end
