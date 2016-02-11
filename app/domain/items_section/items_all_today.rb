module Villeme
  module ItemsSection
    class << self

      def all_today(options = {city: false, type: false, limit: false})
        response = []

        events = if options[:city]
                   options[:city].items.includes(:weeks, :agendas, :place, :subcategories)
                 else
                   self.all.includes(:weeks, :agendas, :place, :subcategories)
                 end

        events.each do |event|
          if event.today?
            response << event
          end
        end

        response
      end

    end
  end
end
