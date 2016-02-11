module Villeme
  module ItemsSection
    class << self

      def all_education_in_city(city, limit = false)
        if limit
          city.events.includes(:categories).where(categories: { slug: Newsfeed.configs[:sections][:education]}).limit(limit)
        else
          city.events.includes(:categories).where(categories: { slug: Newsfeed.configs[:sections][:education] })
        end
      end

    end
  end
end
