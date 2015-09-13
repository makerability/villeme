require 'rails_helper'

describe ItemsController do

  context 'when current user is NOT admin' do
    describe '#index' do
      it 'should redirect user to newsfeed' do
        set_user_logged_in
        create(:event_faker)
        create(:event_faker)

        get(:index, {locale: :en})

        expect(response).to redirect_to(root_path)
      end
    end
  end

  context 'when current user is ADMIN' do
    describe '#index' do
      it 'should redirect user to newsfeed' do
        set_admin_logged_in
        create(:event_faker)
        create(:event_faker)

        get(:index, {locale: :en})

        expect(response.status).to eq(200)
      end
    end
  end


  context 'when current user created the event' do
    describe '#edit' do
      it 'should load page with success' do
        set_user_logged_in(id: 1)
        event = create(:event, user_id: 1)

        get(:edit, {locale: :en, id: event})

        expect(response.status).to eq(200)
      end
    end
  end

  context 'when current user DO NOT created the event' do
    describe '#show' do
      it 'should load page with success' do
        set_user_logged_in(id: 1)
        event = create(:event, user_id: 2)

        get(:show, {locale: :en, id: event})

        expect(response.status).to eq(200)
      end
    end
    describe '#edit' do
      it 'should redirect page to newsfeed' do
        set_user_logged_in(id: 1)
        event = create(:event, user_id: 2)

        get(:edit, {locale: :en, id: event})

        expect(response).to redirect_to(root_path)
      end
    end
  end

end