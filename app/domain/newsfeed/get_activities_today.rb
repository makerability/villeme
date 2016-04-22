module Villeme
  module NewsfeedModule
    module Activities
      class << self

        def get_activities_today(city = false, options = {user: nil, json: false, limit: nil})
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
          activities.count <= 2 ? activities[0...2] : activities[0...5]
        end

        def get_snippet_activities(activities)
          activities.count <= 2 ? activities[2...12] : activities[5...15]
        end

        def create_title
          "Atividades para praticar hoje em #{@city.try(:name)}"
        end

      end
    end
  end
end
