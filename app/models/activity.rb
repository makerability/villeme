class Activity < Item

  def self.all_today(options = Hash(city: false, limit: false))
    activities = if options[:city]
               options[:city].activities
             else
               self
             end

    i = 0
    response = []

    activities.each do |activity|
      if activity.today?
        i == options[:limit] ? break : i += 1 if options[:limit]
        response << activity
      end
    end

    response
  end

end