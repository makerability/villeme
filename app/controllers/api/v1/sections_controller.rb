class Api::V1::SectionsController < Api::V1::ApiController

  require_relative '../../../domain/usecases/events/get_events_section'
  require_relative '../../../domain/usecases/events/get_activity_section'
  require_relative '../../../domain/sections/mount_events_today'
  require_relative '../../../domain/sections/mount_items_agenda'
  require_relative '../../../domain/sections/mount_events_persona'
  require_relative '../../../domain/newsfeed/mount_newsfeed'

	def show
    city = City.find_by(slug: params[:city])

    if params[:when]
      date_filter(city)
    elsif params[:personas]
      persona_filter(city)
    elsif params[:categories]
      category_filter(city)
    else
      show_all(city)
    end
	end


  private

  def show_all(city)
    respond_with Villeme::MountNewsfeed.get_all_sections(city, current_or_guest_user, json: true, upcoming: true)
  end

  def category_filter(city)
    respond_with "abc"
  end

  def persona_filter(city)
    respond_with Villeme::MountSections.get_events_persona(params[:personas], city, user: current_or_guest_user, json: true, upcoming: true, snippet: false)
  end

  def date_filter(city)
    if params[:resource] == 'events'
      respond_with Villeme::MountSections::Events.get_events_today(city, user: current_or_guest_user, json: true, snippet: false)
    elsif params[:resource] == 'activities'
      respond_with Villeme::MountSections::Activities.get_activities_today(city, user: current_or_guest_user, json: true, snippet: false)
    else
      respond_with Villeme::MountSections::Events.get_events_today(city, user: current_or_guest_user, json: true, snippet: false)
    end
  end

end
