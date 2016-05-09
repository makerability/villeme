class Api::V1::UsersController < Api::V1::ApiController

  require_relative '../../../domain/sections/mount_items_agenda'


  def agenda
    respond_with Villeme::MountSections::Agenda.get_items_agenda(current_or_guest_user, json: true)
  end

end
