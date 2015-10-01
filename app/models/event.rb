class Event < Item

  def self.all_today(options = Hash(city: false, limit: false))
    events = if options[:city]
               options[:city].events.includes(:weeks, :agendas, :place, :subcategories)
             else
               self.all.includes(:weeks, :agendas, :place, :subcategories)
             end

    i = 0
    response = []

    events.each do |event|
      if event.today?
        i == options[:limit] ? break : i += 1 if options[:limit]
        response << event
      end
    end

    response
  end

end