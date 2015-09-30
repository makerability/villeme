module Villeme
  module UseCases
    class GetEventsSection
      class << self

        def get_all_sections(city, user)
          {
              all: get_section_all_events(city),
              today: get_section_today_events(city: city),
              persona: create_section_persona_events(user.personas_name, city),
              neighborhood: create_section_neighborhood_events(user.neighborhood),
              fun: create_section_fun_events(city),
              education: create_section_education_events(city),
              health: create_section_health_events(city),
              trends: create_section_trends_events(city)
          }
        end

        def get_section_all_events(city)
          city.events.upcoming
        end

        def get_section_today_events(options = {city: false, limit: nil})
          events_all_today = Event.all_today(options)

          {
              title: "Eventos acontecendo hoje em #{options[:city].name}",
              preview: events_all_today[0...2],
              snippet: events_all_today[2...12],
              count: events_all_today.count,
              link: Rails.application.routes.url_helpers.newsfeed_city_today_path(city: options[:city]),
              city_name: options[:city].name,
              type: 'today'
          }
        end

        def create_section_persona_events(personas, city, options = {limit: nil})
          events_all_persona = Event.all_persona_in_city(personas, city, options).upcoming

          {
              title: "Eventos indicados para você",
              preview: events_all_persona[0...2],
              snippet: events_all_persona[2..12],
              count: events_all_persona.count,
              link: Rails.application.routes.url_helpers.newsfeed_city_persona_path(city: city, personas: personas.join('+')),
              type: 'persona'
          }
        end

        def create_section_neighborhood_events(neighborhood, options = {limit: nil})
          events_all_neighborhood = Event.all_in_neighborhood(neighborhood, options).upcoming
          {
              title: "Eventos acontecendo no bairro #{neighborhood.name}",
              preview: events_all_neighborhood[0...2],
              snippet: events_all_neighborhood[2...12],
              count: events_all_neighborhood.count,
              link: Rails.application.routes.url_helpers.newsfeed_city_neighborhood_path(city: neighborhood.city, neighborhood: neighborhood),
              neighborhood_name: neighborhood.name,
              type: 'neighborhood'
          }

        end

        def create_section_fun_events(city, options = {limit: nil})
          events_all_fun = Event.all_fun_in_city(city, options).upcoming

          {
              title: "Eventos para se divertir",
              preview: events_all_fun[0...2],
              snippet: events_all_fun[2...12],
              count: events_all_fun.count,
              link: Rails.application.routes.url_helpers.newsfeed_city_category_path(city: city, categories: Category.to_query(Newsfeed.configs[:sections][:fun].map(&:capitalize), key: false)),
              type: 'fun'
          }
        end

        def create_section_education_events(city, options = {limit: nil})
          events_all_education = Event.all_education_in_city(city, options).upcoming

          {
              title: "Eventos para aprender algo novo",
              preview: events_all_education[0...2],
              snippet: events_all_education[2...12],
              count: events_all_education.count,
              link: Rails.application.routes.url_helpers.newsfeed_city_category_path(city: city, categories: Category.to_query(Newsfeed.configs[:sections][:education].map(&:capitalize), key: false)),
              type: 'learn'
          }
        end

        def create_section_health_events(city, options = {limit: nil})
          events_all_health = Event.all_health_in_city(city, options).upcoming

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
        def create_section_trends_events(city, options = {limit: nil})
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