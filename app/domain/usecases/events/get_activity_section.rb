module Villeme
  module UseCases
    class GetActivitiesSection
      class << self

        require_relative '../../sections/mount_activities_today'

        def get_all_sections(city, user, options = {json: false})
          data = {
              all: get_section_all_events(city),
              today: Villeme::MountSections::Activities.get_activities_today(city, user: user, json: options[:json]),
              policies: {
                  is_guest_user: user.guest?
              }
          }

          options[:json] ? data.as_json : data
        end

        def get_section_all_events(city)
          city.activities.upcoming
        end

      end
    end
  end
end