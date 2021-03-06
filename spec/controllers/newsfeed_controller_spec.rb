require 'rails_helper'

describe NewsfeedController do

  describe '#index' do
    context 'when current_user logged in, invited and have a city_slug' do
      before(:each) do
        set_user_logged_in
        allow(@user).to receive(:city_slug).and_return(:albany)
        create(:city, name: 'Albany')
      end
      it 'should redirect to newsfeed/city' do
        get :index, locale: :en

        expect(response).to redirect_to(newsfeed_city_path(:albany))
      end
    end

    context 'when current_user logged, invited and DO NOT have a city_slug' do
      before(:each) do
        set_user_logged_in({city_name: 'Rio de Janeiro'})
        allow(@user).to receive(:city_slug).and_return false
        @city = create(:city, name: 'Albany', launch: true)
               create(:city, name: 'Porto Alegre', launch: true)
      end
      it 'should be load the page with success' do
        get :index, locale: :en

        expect(response.status).to redirect_to(newsfeed_city_path(@city.slug))
      end
    end

    context 'current_user logged in and NOT invited' do
      before(:each) do
        set_user_logged_in_not_invited
        allow(controller).to receive(:current_user).and_return(@user)
        allow(@user).to receive(:city_slug).and_return(:albany)
        allow(@user).to receive(:invited).and_return(false)
      end
      it 'should be block access for user' do
        get :index, city: @user.city_slug, locale: :en

        expect(response).to redirect_to(welcome_path)
      end
    end


    context 'guest_user logged in' do
      before(:each) do
        @user = User.new(guest: true, email: "guest_#{Time.now.to_i}#{rand(100)}@example.com")
        allow(controller).to receive(:current_user).and_return(@user)
        allow(@user).to receive(:city_slug).and_return(:albany)
        allow(@user).to receive(:invited).and_return(true)
      end
      it 'should load newsfeed' do
        get :index, city: @user.city_slug, locale: :en

        expect(response).to redirect_to(newsfeed_city_path(:albany))
      end
    end

  end


  describe "#city" do
    context "current_user logged in and invited" do
      context "with categories params" do

        before(:each) do
          set_user_logged_in
          @city = create(:city, name: 'Albany', launch: true)
        end

        it 'should render section template' do
          get :city, locale: :en, city: @city, categories: ['Leisure', 'Culture']

          expect(response).to render_template(:section)
        end

      end
    end
  end


  # describe '#persona' do
  #
  #   context 'current_user logged in and invited' do
  #
  #     before(:each) do
  #       set_user_logged_in
  #     end
  #
  #     it 'should render section template' do
  #       allow(@user).to receive(:persona).and_return(create(:persona))
  #       allow(@user).to receive(:city).and_return(create(:city))
  #       allow(controller).to receive(:current_user){ @user }
  #
  #       get :persona, locale: :en, city: @user.city, personas: "#{@user.personas_query}"
  #
  #       expect(response).to render_template(:section)
  #     end
  #
  #   end
  #
  # end


  describe '#agenda' do
    context 'current_user logged in and invited' do
      before(:each) do
        set_user_logged_in
      end

      it 'should render section template' do
        allow(@user).to receive_message_chain(:items_agenda, :upcoming).and_return(nil)

        get :agenda, locale: :en, user: @user

        expect(response).to render_template(:agenda)
      end
    end
  end




end
