require 'rails_helper'

describe '/en/api/v1/sidebar.json' do

  it 'should load sidebar data' do
    city = create(:city)
    url = "/en/api/v1/sections/#{city.slug}/items.json"

    get url

    expect(response).to be_success
  end
end
