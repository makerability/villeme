module Villeme
  module ItemsSection
    class << self

      def all_trends_in_city(city, options = {user: nil, upcoming: nil, json: false, slug: true, limit: nil})
        if options[:limit]
          city.events.where('agendas_count > 1').order('agendas_count DESC').limit(options[:limit])
        else
          city.events.where('agendas_count > 1').order('agendas_count DESC')
        end
      end

    end
  end
end
