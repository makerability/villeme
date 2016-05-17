require 'rails_helper'

describe Api::V1::SectionsController do

  before(:each) do
    set_user_logged_in
    @city = create(:city)
  end

  describe '#show' do

    it 'should load with success' do
      get :show, resource: :items, city: @city.slug, format: :json

      expect(response.status).to eq(200)
    end
  end

  describe '#show ? when: :today' do

    it 'should load with success' do
      get :show, resource: :items, city: @city.slug, when: :today, format: :json

      expect(response.status).to eq(200)
    end
  end

  describe '#show ? personas: :activist' do

    it 'should load with success' do
      get :show, resource: :items, city: @city.slug, personas: :activist, format: :json

      expect(response.status).to eq(200)
    end
  end

  describe '#category ? categories: :leisure' do

    it 'should load with success' do
      get :show, resource: :items, city: @city.slug, categories: :leisure, format: :json

      expect(response.status).to eq(200)
    end
  end

end
