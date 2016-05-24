module Villeme
  module ItemsSection
    class << self

      def all_in_neighborhood(neighborhoods, options = {user: nil, upcoming: true, json: false, limit: false})
        items = if options[:limit]
                  if options[:upcoming]
                    Item.where(neighborhood_name: neighborhoods).limit(options[:limit]).upcoming
                  else
                    Item.where(neighborhood_name: neighborhoods).limit(options[:limit])
                  end
                elsif options[:upcoming]
                  Item.where(neighborhood_name: neighborhoods).upcoming
                else
                  Item.where(neighborhood_name: neighborhoods)
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
