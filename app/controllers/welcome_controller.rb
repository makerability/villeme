# encoding: utf-8
class WelcomeController < ApplicationController

	require_relative '../domain/invites/create_user_from_invite'

	layout 'welcome'

	def index
		if user_signed_in? and current_user.invited
			redirect_to root_path and return
		end

		if params[:key]
			if Villeme::InvitesDomain.create_user_from_invite(params[:key])
				redirect_to sign_in_path and return
			else
				redirect_to welcome_path and return
			end
  	end

		@invite = Invite.new
    @cities = City.limit(5).order(:goal)
    @invites = Invite.all
  end

end
