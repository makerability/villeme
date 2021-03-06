module Villeme
  module MountNewsfeed
    class << self

      require_relative '../../../app/domain/sections/mount_events_today'
      require_relative '../../../app/domain/sections/mount_events_persona'
      require_relative '../../../app/services/section/mount_events_neighborhood'
      require_relative '../../../app/domain/sections/mount_activities_today'


      def get_all_sections(city, user, options = {json: false, upcoming: true})
        data = {
          all: get_section_all_events(city),
          today: Villeme::MountSections::Events.get_events_today(city, user: user, json: options[:json]),
          persona: Villeme::MountSections::Personas.get_events_persona(user.personas_name, city, user: user, json: options[:json], upcoming: options[:upcoming]),
          neighborhood: SectionService::Neighborhood.get_events_neighborhood(user.neighborhood_name, user: user, json: options[:json], upcoming: options[:upcoming]),
          fun: create_section_fun_events(city, user: user, json: options[:json], slug: true, upcoming: options[:upcoming]),
          education: create_section_education_events(city, user: user, json: options[:json], slug: true, upcoming: options[:upcoming]),
          health: create_section_health_events(city, user: user, json: options[:json], slug: true, upcoming: options[:upcoming]),
          trends: create_section_trends_events(city),
          activitiesToday: Villeme::MountSections::Activities.get_activities_today(city, user: user, json: options[:json]),
          currentUser: {
            firstName: user.first_name,
            username: user.username,
            isGuest: user.guest?,
            agenda: {
              count: user.items_agenda.upcoming.count
            },
          },
          policies: {
            isGuestUser: user.guest?
          }
        }

        options[:json] ? data.as_json : data
      end

      def get_section_all_events(city)
        city.events.upcoming
      end



      def create_section_fun_events(city, options = {user: nil, upcoming: true, json: false, slug: true, limit: nil})
        events_all_fun = Event.all_categories_in_city(Newsfeed.configs[:sections][:fun], city, options)

        {
          title: "Eventos para se divertir",
          items: events_all_fun.count <= 2 ? events_all_fun[0...2] : events_all_fun[0...5],
          snippet: events_all_fun.count <= 2 ? events_all_fun[2...12] : events_all_fun[5...15],
          count: events_all_fun.count,
          link: "?#{{categories: Newsfeed.configs[:sections][:fun].map(&:capitalize)}.to_query}",
          link_to_create: '/events/new',
          type: 'fun'
        }
      end

      def create_section_education_events(city, options = {user: nil, upcoming: true, json: false, slug: true, limit: nil})
        events_all_education = Event.all_categories_in_city(Newsfeed.configs[:sections][:education], city, options)

        {
          title: "Eventos para aprender algo novo",
          items: events_all_education.count <= 2 ? events_all_education[0...2] : events_all_education[0...5],
          snippet: events_all_education.count <= 2 ? events_all_education[2...12] : events_all_education[5...15],
          count: events_all_education.count,
          link: "?#{{categories: Newsfeed.configs[:sections][:education].map(&:capitalize)}.to_query}",
          link_to_create: '/events/new',
          type: 'learn'
        }
      end

      def create_section_health_events(city, options = {user: nil, upcoming: true, json: false, slug: true, limit: nil})
        events_all_health = Event.all_categories_in_city(Newsfeed.configs[:sections][:health], city, options)

        {
          title: "Eventos para cuidar da saude",
          items: events_all_health.count <= 2 ? events_all_health[0...2] : events_all_health[0...5],
          snippet: events_all_health.count <= 2 ? events_all_health[2...12] : events_all_health[5...15],
          count: events_all_health.count,
          link: "?#{{categories: Newsfeed.configs[:sections][:health].map(&:capitalize)}.to_query}",
          type: 'health'
        }
      end

      # TODO: Create a route system to trends events
      def create_section_trends_events(city, options = {user: nil, upcoming: nil, json: false, slug: true, limit: nil})
        events_all_trends = Event.all_trends_in_city(city, options).upcoming

        {
          title: "Eventos em alta",
          items: events_all_trends[0...2],
          snippet: events_all_trends[2...12],
          count: events_all_trends.count,
          link: nil,
          type: 'trends'
        }
      end


    end
  end
end
