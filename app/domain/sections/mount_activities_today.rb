module Villeme
  module MountSections
    module Activities
      class << self

        def get_activities_today(city = false, options = {user: nil, json: false, limit: nil, principal_size: 2, snippet_size: 12, snippet: true})
          @city = city
          @options = options

          create_json(activities_today)
        end


        private

        def activities_today
          Activity.all_today(@city, @options)
        end

        def create_json(activities)
          {
              title: create_title,
              items: get_principal_activities(activities),
              snippet: get_snippet_activities(activities),
              count: activities.count,
              link: create_link,
              link_to_create: '/activities/new',
              city_name: @city.name,
              type: 'activities-today'
          }
        end

        def create_link
          if @city
            Rails.application.routes.url_helpers.newsfeed_city_today_path(
                city: @city,
                resource: 'activities'
              )
          else
            nil
          end
        end

        def get_principal_activities(activities)
          if is_snippet?
            activities[0...get_principal_size]
          else
            activities
          end
        end

        def get_snippet_activities(activities)
          if is_snippet?
            activities[get_principal_size..get_snippet_size]
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
          "Atividades para praticar hoje em #{@city.try(:name)}"
        end

      end
    end
  end
end
