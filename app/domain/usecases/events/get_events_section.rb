module Villeme
  module UseCases
    class GetEventsSection

      require_relative '../../../../app/domain/newsfeed/get_events_today'
      require_relative '../../../../app/domain/newsfeed/get_events_persona'
      require_relative '../../../../app/domain/newsfeed/get_events_neighborhood'

      class << self

        def get_all_sections(city, user, options = {json: false, upcoming: true})
          data = {
              all: get_section_all_events(city),
              today: Villeme::NewsfeedModule::Today.get_events_today(city, user: user, json: options[:json]),
              persona: Villeme::NewsfeedModule::Persona.get_events_persona(user.personas_name, city, user: user, json: options[:json], upcoming: options[:upcoming]),
              neighborhood: Villeme::NewsfeedModule::Neighborhood.get_events_neighborhood(user.neighborhood, user: user, json: options[:json], upcoming: options[:upcoming]),
              fun: create_section_fun_events(city, user: user, json: options[:json], slug: true, upcoming: options[:upcoming]),
              education: create_section_education_events(city, user: user, json: options[:json], slug: true, upcoming: options[:upcoming]),
              health: create_section_health_events(city, user: user, json: options[:json], slug: true, upcoming: options[:upcoming]),
              trends: create_section_trends_events(city),
              current_user: {
                  username: user.username,
                  is_guest: user.guest?,
                  agenda: {
                      count: user.agenda_items.upcoming.count
                  },
              },
              policies: {
                  is_guest_user: user.guest?
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
              link: Rails.application.routes.url_helpers.newsfeed_city_category_path(city: city, categories: Category.to_query(Newsfeed.configs[:sections][:fun].map(&:capitalize), key: false)),
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
              link: Rails.application.routes.url_helpers.newsfeed_city_category_path(city: city, categories: Category.to_query(Newsfeed.configs[:sections][:education].map(&:capitalize), key: false)),
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
              link: Rails.application.routes.url_helpers.newsfeed_city_category_path(city: city, categories: Category.to_query(Newsfeed.configs[:sections][:health].map(&:capitalize), key: false)),
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
end
