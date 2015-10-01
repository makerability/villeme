class Event < Item

  def self.all_today(options = Hash(city: false, limit: false))
    events = if options[:city]
               options[:city].events
             else
               self
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