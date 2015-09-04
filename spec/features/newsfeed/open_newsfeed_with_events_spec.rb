require 'rails_helper'


describe 'Open the newsfeed with two events' do

  before(:all) do
    I18n.locale = 'pt-BR'
  end

  before(:each) do
    DatabaseCleaner.clean!
    create(:persona_faker)
    create(:city_faker, launch: true)
  end

  context 'when user is a guest' do
    before(:each) do
      user = create(:user, guest: true)
      login_as(user, :scope => :user)
    end

    it 'display the newsfeed with two events from the first city' do
      event_a = create(:event_faker, date_start: Date.current - 3, date_finish: Date.current + 10)
        allow(event_a).to receive(:place).and_return(create(:place_faker))
      event_b = create(:event_faker, date_start: Date.current - 3, date_finish: Date.current + 10)
        allow(event_b).to receive(:place).and_return(create(:place_faker))
      event_c = create(:event_faker, date_start: Date.current - 30, date_finish: Date.current + -3)
        allow(event_c).to receive(:place).and_return(create(:place_faker))
      neighborhood = create(:neighborhood)
        allow(neighborhood).to receive(:events).and_return([event_a, event_b, event_c])

      visit ('/newsfeed')

      expect(page).to have_content(event_a.name)
      expect(page).to have_content(event_b.name)
    end

    it 'display button to guest user do login' do
      event_a = create(:event_faker, date_start: Date.current - 3, date_finish: Date.current + 10)
      allow(event_a).to receive(:place).and_return(create(:place_faker))
      event_b = create(:event_faker, date_start: Date.current - 3, date_finish: Date.current + 10)
      allow(event_b).to receive(:place).and_return(create(:place_faker))
      event_c = create(:event_faker, date_start: Date.current - 30, date_finish: Date.current + -3)
      allow(event_c).to receive(:place).and_return(create(:place_faker))
      neighborhood = create(:neighborhood)
        allow(neighborhood).to receive(:events).and_return([event_a, event_b, event_c])

      visit ('/newsfeed')

      expect(page).to have_content('Entrar ou solicitar convite')
    end

  end

  context 'when user is logged' do
    before(:each) do
      user = create(:user, guest: false, invited: true)
      login_as(user, :scope => :user)
    end

    it 'display the newsfeed with two events from the first city' do
      event_a = create(:event_faker, date_start: Date.current - 3, date_finish: Date.current + 10)
        allow(event_a).to receive(:place).and_return(create(:place_faker))
      event_b = create(:event_faker, date_start: Date.current - 3, date_finish: Date.current + 10)
        allow(event_b).to receive(:place).and_return(create(:place_faker))
      event_c = create(:event_faker, date_start: Date.current - 30, date_finish: Date.current + -3)
        allow(event_c).to receive(:place).and_return(create(:place_faker))
      neighborhood = create(:neighborhood)
        allow(neighborhood).to receive(:events).and_return([event_a, event_b, event_c])

      visit ('/newsfeed')

      expect(page).to have_content(event_a.name)
      expect(page).to have_content(event_b.name)
      expect(page).should_not have_content(event_c.name)
    end

    it 'display the button to current_user do logout' do
      event_a = create(:event_faker, date_start: Date.current - 3, date_finish: Date.current + 10)
      allow(event_a).to receive(:place).and_return(create(:place_faker, id: 2432))
      event_b = create(:event_faker, date_start: Date.current - 3, date_finish: Date.current + 10)
      allow(event_b).to receive(:place).and_return(create(:place_faker, id: 321))
      event_c = create(:event_faker, date_start: Date.current - 30, date_finish: Date.current + -3)
      allow(event_c).to receive(:place).and_return(create(:place_faker, id: 123))
      neighborhood = create(:neighborhood)
        allow(neighborhood).to receive(:events).and_return([event_a, event_b, event_c])

      visit ('/newsfeed')

      expect(page).to have_content('Sair')
    end
  end

  after(:all) do
    I18n.locale = :en
  end

end

