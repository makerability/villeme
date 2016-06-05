class Event < Item

  def self.all_today(city = false, options = {user: nil, json: false, limit: false})
    response = []

    events = if city
               city.events.includes(:weeks, :agendas, :place, :subcategories)
             else
               self.all.includes(:weeks, :agendas, :place, :subcategories)
             end

    events.each do |event|
      if event.today?
        event = Item.to_json(event, options) if options[:json]
        response << event
      end
    end

    return response
  end
end