module Villeme
  module UseCases
    class GetActivitiesSection
      class << self

        def get_all_sections(city, user, options = {json: false})
          data = {
              all: get_section_all_events(city),
              today: get_section_today_activities(city, user: user, json: options[:json]),
              policies: {
                  is_guest_user: user.guest?
              }
          }

          options[:json] ? data.as_json : data
        end

        def get_section_all_events(city)
          city.activities.upcoming
        end

        def get_section_today_activities(city, options = {user: nil, json: false, limit: nil})
          activities_all_today = Activity.all_today(city, options)

          {
              title: "Atividades para praticar hoje em #{city.name}",
              items: activities_all_today[0...2],
              snippet: activities_all_today[2...12],
              count: activities_all_today.count,
              link: Rails.application.routes.url_helpers.newsfeed_city_today_path(city: city, type: 'Activity'),
              link_to_create: '/activities/new',
              city_name: city.name,
              type: 'activities-today'
          }
        end



      end
    end
  end
end