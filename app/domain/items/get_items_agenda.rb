module Villeme
  module ItemsSection
    class << self

      def agenda(user, options = {limit: false, upcoming: true, json: false})
        options[:user] = user

        if options[:limit] and user.try(:items_agenda)
          user.items_agenda.limit(options[:limit])
        elsif user.try(:items_agenda)
          items = if options[:upcoming]
                    user.items_agenda.upcoming
                  else
                    user.items_agenda
                  end

          if options[:json]
            return Item.items_to_json(items, options)
          else
            return items
          end
        else
          Item.none
        end
      end

    end
  end
end
