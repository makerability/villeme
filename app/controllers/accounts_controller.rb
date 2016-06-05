# encoding: utf-8

class AccountsController < ApplicationController

  require_relative '../domain/usecases/geolocalization/create_object_geocoded'
  require_relative '../services/account/set_account_completed'
  require_relative '../domain/user/create_username'

  before_action :is_logged

	before_action :current_user_home

	layout 'centralize'



  def edit
  	@user = current_user
  end


  def update

    AccountService.set_completed(current_user)
    Villeme::UseCases::CreateObjectGeocoded.new(user_params[:address]).create_objects

    respond_to do |format|
      if current_user.update(user_params)
        format.html { redirect_to user_account_path(current_user), notice: 'Você atualizou sua conta com sucesso!' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end  	
  end



  private


    def set_event
      @event = Event.find(params[:id])
    end  

    def user_params
      params.require(:user).permit(:name, :username, :email, :avatar, :address, :persona_ids => [])
    end  

end
