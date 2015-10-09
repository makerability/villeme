module Villeme
  module UseCases
    class GetEventsSection
      class << self

        def get_all_sections(city, user, options = {json: false})
          data = {
              all: get_section_all_events(city),
              today: get_section_today_events(city, user: user, json: options[:json]),
              persona: create_section_persona_events(user.personas_name, city, user: user, json: options[:json]),
              neighborhood: create_section_neighborhood_events(user.neighborhood, user: user, json: options[:json]),
              fun: create_section_fun_events(city, user: user, json: options[:json], slug: true),
              education: create_section_education_events(city, user: user, json: options[:json], slug: true),
              health: create_section_health_events(city, user: user, json: options[:json], slug: true),
              trends: create_section_trends_events(city),
              policies: {
                  is_guest_user: user.guest?
              }
          }

          options[:json] ? data.as_json : data
        end

        def get_section_all_events(city)
          city.events.upcoming
        end

        def get_section_today_events(city = false, options = {user: nil, json: false, limit: nil})
          events_all_today = Event.all_today(city, options)

          {
              title: "Eventos acontecendo hoje em #{city.name}",
              preview: events_all_today[0...2],
              snippet: events_all_today[2...12],
              count: events_all_today.count,
              link: Rails.application.routes.url_helpers.newsfeed_city_today_path(city: city, type: 'Event'),
              link_to_create: 'events/new',
              city_name: city.name,
              type: 'today'
          }
        end

        def create_section_persona_events(personas, city, options = {user: nil, upcoming: true, json: false, limit: nil})
          events_all_persona = Event.all_persona_in_city(personas, city, options)

          {
              title: "Eventos indicados para você",
              preview: events_all_persona[0...2],
              snippet: events_all_persona[2..12],
              count: events_all_persona.count,
              link: Rails.application.routes.url_helpers.newsfeed_city_persona_path(city: city, personas: personas.join('+')),
              link_to_create: 'events/new',
              type: 'persona'
          }
        end

        def create_section_neighborhood_events(neighborhood, options = {user: nil, upcoming: true, json: false, limit: nil})
          events_all_neighborhood = Event.all_in_neighborhood(neighborhood, options)
          {
              title: "Eventos acontecendo no bairro #{neighborhood.name}",
              preview: events_all_neighborhood[0...2],
              snippet: events_all_neighborhood[2...12],
              count: events_all_neighborhood.count,
              link: Rails.application.routes.url_helpers.newsfeed_city_neighborhood_path(city: neighborhood.city, neighborhood: neighborhood),
              link_to_create: 'events/new',
              neighborhood_name: neighborhood.name,
              type: 'neighborhood'
          }

        end

        def create_section_fun_events(city, options = {user: nil, upcoming: true, json: false, slug: true, limit: nil})
          events_all_fun = Event.all_categories_in_city(Newsfeed.configs[:sections][:fun], city, options)

          {
              title: "Eventos para se divertir",
              preview: events_all_fun[0...2],
              snippet: events_all_fun[2...12],
              count: events_all_fun.count,
              link: Rails.application.routes.url_helpers.newsfeed_city_category_path(city: city, categories: Category.to_query(Newsfeed.configs[:sections][:fun].map(&:capitalize), key: false)),
              link_to_create: 'events/new',
              type: 'fun'
          }
        end

        def create_section_education_events(city, options = {user: nil, upcoming: true, json: false, slug: true, limit: nil})
          events_all_education = Event.all_categories_in_city(Newsfeed.configs[:sections][:education], city, options)

          {
              title: "Eventos para aprender algo novo",
              preview: events_all_education[0...2],
              snippet: events_all_education[2...12],
              count: events_all_education.count,
              link: Rails.application.routes.url_helpers.newsfeed_city_category_path(city: city, categories: Category.to_query(Newsfeed.configs[:sections][:education].map(&:capitalize), key: false)),
              link_to_create: 'events/new',
              type: 'learn'
          }
        end

        def create_section_health_events(city, options = {user: nil, upcoming: true, json: false, slug: true, limit: nil})
          events_all_health = Event.all_categories_in_city(Newsfeed.configs[:sections][:health], city, options)

          {
              title: "Eventos para cuidar da saude",
              preview: events_all_health[0...2],
              snippet: events_all_health[2...12],
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
              preview: events_all_trends[0...2],
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