module AccountService

  require_relative '../../../app/services/account/is_account_complete'

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
    AccountService.is_account_complete?(user)
  end


end
