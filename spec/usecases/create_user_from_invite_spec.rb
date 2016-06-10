require 'rails_helper'
require_relative '../../app/services/invite/create_user_from_invite'

describe 'InvitesDomain' do

  describe '.create_user_from_invite' do
    before(:each) do
      invite = build(:invite, name: 'Capitol Hill', email: 'test@gmail.com', key: 'dsakjeianasoid')
      user = build(:user, email: 'test@gmail.com')
      allow(Invite).to receive(:find_by).with(key: 'dsakjeianasoid').and_return invite
      allow(User).to receive(:find_by).with(email: 'test@gmail.com').and_return user
    end
    context "when invite_key == dsakjeianasoid" do
      it "does return true" do
        output = InviteService.create_user_from_invite('dsakjeianasoid')
        expect(output).to eq(true)
      end
    end
    context "when invite_key == invalid" do
      before(:each) do
        allow(Invite).to receive(:find_by).with(key: 'invalid').and_return nil
      end
      it "does return false" do
        output = InviteService.create_user_from_invite('invalid')
        expect(output).to eq(false)
      end
    end
  end

end
