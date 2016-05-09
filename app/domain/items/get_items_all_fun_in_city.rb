module Villeme
  module ItemsSection
    class << self

      def all_fun_in_city(city, options = {user: nil, upcoming: true, json: false, limit: false})
        items = if options[:limit]
                  if options[:upcoming]
                    city.events.includes(:categories).where(categories: { slug: Newsfeed.configs[:sections][:fun]}).limit(options[:limit]).upcoming
                  else
                    city.events.includes(:categories).where(categories: { slug: Newsfeed.configs[:sections][:fun]}).limit(options[:limit])
                  end
                else
                  if options[:upcoming]
                    city.events.includes(:categories).where(categories: { slug: Newsfeed.configs[:sections][:fun]}).upcoming
                  else
                    city.events.includes(:categories).where(categories: { slug: Newsfeed.configs[:sections][:fun]})
                  end
                end

        if options[:json]
          Item.items_to_json(items, options)
        else
          items
        end
      end

    end
  end
end
