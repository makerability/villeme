module Villeme
  module InvitesDomain
    extend self

    def create_user_from_invite(invite_key)
        @key = invite_key
        @invite = Invite.find_by(key: @key)
        @invite.nil? ? do_not_create_user : create_or_update_user
    end

    private

    def do_not_create_user
      return false
    end

    def create_or_update_user
      @user = User.find_by(email: @invite.email)
      user_not_exist? ? create_user : update_user
      return true
    end

    def user_not_exist?
      @user.blank?
    end

    def create_user
      new_user = User.create({
        name: @invite.name,
        email: @invite.email,
        password: @invite.password,
        address: @invite.address,
        invited: true})

      new_user.personas << @invite.personas
    end

    def update_user
      @user.update_attributes(persona_id: @invite.persona, invited: true, address: @invite.address)
    end

  end
end
