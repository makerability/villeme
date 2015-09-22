require 'rails_helper'

describe ':city' do
  context 'when user have a city_slug' do
    it 'should load current_user city' do
      user = double("User")
      create(:city)
      allow(user).to receive(:city_slug).and_return('albany')

      expect(get: "#{user.city_slug}").to route_to(controller: 'newsfeed',
                                                   action: 'city',
                                                   city: 'albany'
                                          )
    end
  end

  context 'when user DO NOT have a city_slug' do
    it 'should load city default' do
      city = create(:city, launch: true)
      user = double("User", city_slug: nil)
      allow(user).to receive(:city_slug).and_return(nil)

      expect(get: '/albany').to route_to(controller: 'newsfeed',
                                   action: 'city',
                                   city: 'albany'
                          )
    end
  end

end


