# encoding: utf-8
class WelcomeController < ApplicationController

	require_relative '../services/invite/create_user_from_invite.rb'

	layout 'welcome'

	def index
		if user_signed_in? and current_user.invited
			redirect_to root_path and return
		end

		if params[:key]
			if InviteService.create_user_from_invite(params[:key])
				redirect_to sign_in_path, alert: 'Faça login com a senha enviada por email.' and return
			else
				redirect_to welcome_path, alert: 'Este convite já foi utilizado ou é invalido.' and return
			end
		end

		@invite = Invite.new
		@cities = City.limit(5).order(:goal)
		@invites = Invite.all
	end

end
