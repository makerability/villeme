# encoding: utf-8
class InvitesController < ApplicationController
  before_action :set_invite, only: [:show, :edit, :update, :destroy]
  before_action :is_admin, except: :create

  layout 'fullwidth_layout'

  # GET /invites
  # GET /invites.json
  def index
    @invites = Invite.all
  end

  # GET /invites/1
  # GET /invites/1.json
  def show
  end

  # GET /invites/new
  def new
    @invite = Invite.new
  end

  # GET /invites/1/edit
  def edit
  end

  # POST /invites
  # POST /invites.json
  def create
    if invite_not_exist?
      @invite = Invite.new(invite_params)
      save_and_redirect_to_welcome
    else
      redirect_to welcome_path, notice: I18n.t('invite_create.repeated', user_name: invite_params[:name].split.first)
    end
  end



  # PATCH/PUT /invites/1
  # PATCH/PUT /invites/1.json
  def update
    respond_to do |format|
      if @invite.update(invite_params)
        format.html { redirect_to @invite, notice: 'Convite editado!' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @invite.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invites/1
  # DELETE /invites/1.json
  def destroy
    @invite.destroy
    respond_to do |format|
      format.html { redirect_to invites_url }
      format.json { head :no_content }
    end
  end

  def send_invite
    @invite = Invite.find_by(key: params[:key])
    InviteMailer.send_key(@invite).deliver
    @invite.update_attributes(invited: true)
    render js: "alert('Convite enviado!');"
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_invite
    @invite = Invite.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def invite_params
    params.require(:invite).permit(:user_id,
    :email,
    :name,
    :address,
    :persona_sugest,
    :city_sugest,
    :locale,
    :key,
    :persona_ids => []
    )
  end
end

def save_and_redirect_to_welcome
  if @invite.save
    InviteMailer.welcome_email(@invite).deliver unless Rails.env.test?
    redirect_to welcome_path, notice: I18n.t('invite_create.valid', user_name: @invite.name.split.first)
  else
    redirect_to welcome_path, alert: I18n.t('invite_create.invalid')
  end
end

def invite_not_exist?
  searchable_invite = Invite.where(email: invite_params[:email]).first
  searchable_invite.blank?
end
