class Api::V1::SectionsController < Api::V1::ApiController

  require_relative '../../../domain/usecases/events/get_events_section'

	def items
		city = City.find_by(slug: params[:city])
		section_items = Villeme::UseCases::GetEventsSection.get_all_sections(city, current_or_guest_user, json: true, upcoming: true)
		respond_with section_items
	end

end
