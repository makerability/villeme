class Activity < Item

  def self.all_today(city = false, options = {user: nil, json: false, limit: false})
    response = []

    activities = if city
                   city.activities.includes(:weeks, :agendas, :place, :subcategories)
                 else
                   self.all.includes(:weeks, :agendas, :place, :subcategories)
                 end

    activities.each do |activity|
      if activity.today?
        activity = Item.to_json(activity, options) if options[:json]
        response << activity
      end
    end

    return response
  end

end