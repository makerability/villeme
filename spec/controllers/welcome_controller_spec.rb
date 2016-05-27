require 'rails_helper'

describe WelcomeController, type: :controller do

  describe '#index' do

    context 'current_user logged in' do
      before(:each) do
        set_user_logged_in
        allow(@user).to receive(:city_slug).and_return(:albany)
        allow(controller).to receive(:current_user) { @user }
      end
      it 'should redirected to NewsfeedController#index' do
        get :index, locale: :en

        expect(response).to redirect_to(root_path)
      end
    end

    context 'current_user NOT logged in' do
      before(:each) do
        set_current_user_nil
      end

      it 'should load page with success' do
        get :index, locale: :en

        expect(response).to have_http_status(:success)
      end
    end

    context 'params[:key]' do
      context 'current_user has an VALID invite key and' do
        context 'signed_in? FALSE' do
          it 'should redirect to sign in' do
            set_current_user_nil
            invited_user = build(:user, email: 'test@gmail.com')
            allow(User).to receive(:find_by) { invited_user }
            invite = build(:invite, email: 'test@gmail.com')
            allow(Invite).to receive(:find_by) { invite }

            get :index, key: invite.key

            expect(response).to redirect_to sign_in_path
          end
        end

        context 'signed_in? TRUE' do
          it 'should redirect to newsfeed' do
            set_user_logged_in
            invited_user = build(:user, email: 'test@gmail.com')
            allow(User).to receive(:find_by) { invited_user }
            invite = build(:invite, email: 'test@gmail.com')

            get :index, key: invite.key

            expect(response).to redirect_to root_path
          end
        end
      end

      context 'current_user has an INVALID invite key' do
        context 'signed_in? FALSE' do
          it 'should redirect to welcome page' do
            set_current_user_nil
            invalid_invite = build(:invite, key: '987654321')

            get :index, key: 'keyn0texisted'

            expect(response).to redirect_to welcome_path
          end
        end
      end
    end

  end
end
