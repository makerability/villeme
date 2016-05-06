module Villeme
  module ItemsSection
    class << self

      def all_categories_in_city(categories, city, options = {user: nil, slug: false, upcoming: true, json: false, limit: false})

        items = if options[:limit] and city.try(:items)
                  if options[:upcoming]
                    city.items.includes(categories: :translations).where(category_translations: { name: categories }).limit(options[:limit]).upcoming
                  else
                    city.items.includes(categories: :translations).where(category_translations: { name: categories }).limit(options[:limit])
                  end
                elsif city.try(:items)
                  if options[:upcoming]
                    city.items.includes(categories: :translations).where(category_translations: { name: categories }).upcoming
                  else
                    city.items.includes(categories: :translations).where(category_translations: { name: categories })
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
