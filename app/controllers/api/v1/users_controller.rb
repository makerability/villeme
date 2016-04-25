class Api::V1::UsersController < Api::V1::ApiController

  require_relative '../../../domain/newsfeed/get_items_agenda'


  def agenda
    respond_with Villeme::NewsfeedModule::Agenda.get_items_agenda(current_or_guest_user, json: true)
  end

end
