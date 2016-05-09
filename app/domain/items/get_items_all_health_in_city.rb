module Villeme
  module ItemsSection
    class << self

      def all_health_in_city(city, limit = false)
        if limit
          city.events.includes(:categories).where(categories: { slug: Newsfeed.configs[:sections][:health]}).limit(limit)
        else
          city.events.includes(:categories).where(categories: { slug: Newsfeed.configs[:sections][:health] })
        end
      end

    end
  end
end
