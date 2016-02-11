module Villeme
  module ItemsSection
    class << self

      def all_in_neighborhood(neighborhood, options = {user: nil, upcoming: true, json: false, limit: false})
        items = if options[:limit] and neighborhood.try(:events)
                  if options[:upcoming]
                    neighborhood.events.limit(options[:limit]).upcoming
                  else
                    neighborhood.events.limit(options[:limit])
                  end
                elsif neighborhood.try(:events)
                  if options[:upcoming]
                    neighborhood.events.upcoming
                  else
                    neighborhood.events
                  end
                else
                  Event.none
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
