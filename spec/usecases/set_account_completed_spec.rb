require 'rails_helper'
require_relative '../../app/services/account/set_account_completed'

describe 'UseCases::SetAccountCompleted' do

  context 'when user account is complete' do

    it 'should return true on completed account' do
      user = build(:user, account_complete: false)
      allow(user).to receive(:personas).and_return([1])

      result = AccountService.set_completed(user)

      expect(result).to be_truthy
    end

    it 'should set  user.account_complete to true' do
      user = build(:user, account_complete: false)
      allow(user).to receive(:personas).and_return([1])

      AccountService.set_completed(user)

      expect(user.account_complete).to be_truthy
    end
  end

  context 'when user account is NOT complete' do
    it 'should set attribute account_complete to true' do
      user = build(:user, account_complete: false)
      allow(user).to receive(:personas).and_return([])

      result = AccountService.set_completed(user)

      expect(result).to be_falsey
    end
  end

end