require 'rails_helper'

describe '/en/api/v1/sections/:resource/:city.json' do

  it 'should load with success' do
    city = create(:city)
    url = "/en/api/v1/sections/items/#{city.slug}.json"

    get url

    expect(response).to be_success
  end
end

describe '/en/api/v1/sections/:resource/:city/today.json' do

  it 'should load with success' do
    city = create(:city)
    url = "/en/api/v1/sections/items/#{city.slug}/today.json"

    get url

    expect(response).to be_success
  end
end