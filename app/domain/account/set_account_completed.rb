module AccountDomain

  require_relative '../../domain/policies/user/account_complete.rb'

  extend self

  def set_completed(user)
    if account_completed?(user)
      user.update_attributes(account_complete: true)
      return true
    end

    false
  end


  private

  def account_completed?(user)
    Villeme::Policies::AccountComplete.is_complete?(user)
  end


end
