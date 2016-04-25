require 'rails_helper'

describe Api::V1::SectionsController do

  before(:each) do
    set_user_logged_in
    @city = create(:city)
  end

  describe '#all' do

    it 'should load with success' do
      get :all, resource: :items, city: @city.slug, format: :json

      expect(response.status).to eq(200)
    end
  end

  describe '#today' do

    it 'should load with success' do
      get :today, resource: :items, city: @city.slug, format: :json

      expect(response.status).to eq(200)
    end
  end

end