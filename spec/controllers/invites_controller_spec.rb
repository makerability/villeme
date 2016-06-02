require 'rails_helper'

describe InvitesController, type: :controller do

  before(:each) do
    set_current_user_nil
  end

  describe 'POST #create' do
    context "when user do not have an invite" do
      it 'should create an invite' do
        post :create, invite: attributes_for(:invite)
        expect(Invite.last).to have_attributes(name: 'John Doe', password: String)
      end
      it 'should redirect to welcome' do
        post :create, invite: attributes_for(:invite)
        expect(response).to redirect_to(welcome_path)
      end
    end

  end

end
