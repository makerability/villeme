module Villeme
  module ItemsSection
    class << self

      def all_categories_in_city(categories, city, options = {user: nil, slug: false, upcoming: true, json: false, limit: false})
        name_or_slug_key = options[:slug] ? { slug: categories } : { name: categories }

        items = if options[:limit] and city.try(:items)
                  if options[:upcoming]
                    city.items.includes(:categories).where(categories: name_or_slug_key).limit(options[:limit]).upcoming
                  else
                    city.items.includes(:categories).where(categories: name_or_slug_key).limit(options[:limit])
                  end
                elsif city.try(:items)
                  if options[:upcoming]
                    city.items.includes(:categories).where(categories: name_or_slug_key).upcoming
                  else
                    city.items.includes(:categories).where(categories: name_or_slug_key)
                  end
                else
                  Item.none
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
