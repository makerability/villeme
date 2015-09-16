module Villeme
  module UseCases
    class GetEventsSection
      class << self

        def create_all_sections(city, user)
          {
              all: create_section_all_events(city),
              today: create_section_today_events(city: city, limit: 15),
              persona: create_section_persona_events(user.personas, city, {limit: 2}),
              neighborhood: create_section_neighborhood_events(user.neighborhood, {limit: 2}),
              fun: create_section_fun_events(city, {limit: 2}),
              education: create_section_education_events(city, {limit: 2}),
              health: create_section_health_events(city, {limit: 2}),
              trends: create_section_trends_events(city, {limit: 5})
          }
        end

        def create_section_all_events(city)
          city.events.upcoming
        end

        def create_section_today_events(options = {city: false, limit: 5})
          event_all_today = Event.all_today(options)

          {
              preview: event_all_today[0...2],
              snippet: event_all_today[2...12],
              count: event_all_today.count
          }
        end

        def create_section_persona_events(personas, city, options = {limit: 5})
          Event.all_persona_in_city(personas, city, options).upcoming
        end

        def create_section_neighborhood_events(neighborhood, options = {limit: 5})
          Event.all_in_neighborhood(neighborhood, options).upcoming
        end

        def create_section_fun_events(city, options = {limit: 5})
          Event.all_fun_in_city(city, options).upcoming
        end

        def create_section_education_events(city, options = {limit: 5})
          Event.all_education_in_city(city, options).upcoming
        end

        def create_section_health_events(city, options = {limit: 5})
          Event.all_health_in_city(city, options).upcoming
        end

        def create_section_trends_events(city, options = {limit: 5})
          Event.all_trends_in_city(city, options).upcoming
        end

      end
    end
  end
end