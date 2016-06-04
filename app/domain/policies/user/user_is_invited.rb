module UserPolicies
  extend self

  def user_is_invited?(user)
    @user = user
    if is_user_guest_or_invited?
      true
    elsif is_user_invited_and_has_facebook_provider?
      false
    else
      false
    end
  end

  private

  def is_user_guest_or_invited?
    @user.invited? or @user.guest?
  end

  def is_user_invited_and_has_facebook_provider?
    @user.invited? == false and @user.provider == 'facebook'
  end

end
