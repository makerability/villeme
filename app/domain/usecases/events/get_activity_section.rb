module Villeme
  module UseCases
    class GetActivitiesSection
      class << self

        def get_all_sections(city, user)
          {
              all: get_section_all_events(city),
              today: get_section_today_activities(city: city)
          }
        end

        def get_section_all_events(city)
          city.activities.upcoming
        end

        def get_section_today_activities(options = {city: false, limit: nil})
          activities_all_today = Activity.all_today(options)

          {
              title: "Atividades para praticar hoje em #{options[:city].name}",
              preview: activities_all_today[0...2],
              snippet: activities_all_today[2...12],
              count: activities_all_today.count,
              link: Rails.application.routes.url_helpers.newsfeed_city_today_path(city: options[:city], type: 'Activity'),
              city_name: options[:city].name,
              type: 'activities-today'
          }
        end



      end
    end
  end
end