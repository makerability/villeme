module InviteModule

  include GeocodedActions

  def create_user_from_invite(key)
    invite = Invite.find_by(key: key)
    redirect_to welcome_path and return if invite.nil?

    user = User.find_by(email: invite.email)

    if user_not_exist?(user)
      user = user_create(invite)
      redirect_to sign_in_path and return
    else
      user_update(invite, user)
      redirect_to sign_in_path and return
    end
  end


  # helpers methods

  def user_not_exist?(user)
    user.blank?
  end

  def user_create(invite)
    user = User.create(name: invite.name, email: invite.email, password: Devise.friendly_token[0, 6], invited: true, address: invite.address)

    user.personas << invite.personas

    return user
  end

  def user_update(invite, user)
    user.update_attributes(persona_id: invite.persona, invited: true, address: invite.address)
  end

end
