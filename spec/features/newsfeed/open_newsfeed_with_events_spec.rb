require 'rails_helper'


describe 'Open the newsfeed with two events', js: true do

  before(:all) do
    I18n.locale = 'pt-BR'
  end

  before(:each) do
    DatabaseCleaner.start
    @persona = create(:persona_faker)
    @city = create(:city, launch: true)
    @neighborhood = create(:neighborhood)
  end

  after(:each) do
    DatabaseCleaner.clean
  end

  after(:all) do
    I18n.locale = :en
  end


  context 'when user is a guest' do
    before(:each) do
      @user = create(:user, guest: true)
      login_as(@user, :scope => :user)
    end

    it 'display the newsfeed with two events from the first city' do
      event_a = create(:event_faker, date_start: Date.current - 3, date_finish: Date.current + 10)
        allow(event_a).to receive(:place).and_return(create(:place_faker))
      event_b = create(:event_faker, date_start: Date.current - 3, date_finish: Date.current + 10)
        allow(event_b).to receive(:place).and_return(create(:place_faker))
      event_c = create(:event_faker, date_start: Date.current - 30, date_finish: Date.current + -3)
        allow(event_c).to receive(:place).and_return(create(:place_faker))

      allow(Event).to receive(:all_today).and_return([event_a, event_b, event_c])

      visit ('/newsfeed')

      expect(page).to have_content(City.first.name)
      expect(page).to have_content(event_a.name[0..10])
      expect(page).to have_content(event_b.name[0..10])
    end

    it 'display button to guest user do login' do

      visit ('/newsfeed')

      expect(page).to have_content('Entrar ou criar conta')
    end

  end

  context 'when user is logged' do
    before(:each) do
      @user = create(:user, guest: false, invited: true)
             login_as(@user, :scope => :user)
             allow(@user).to receive(:city).and_return(@city)
    end

    it 'display the newsfeed with two events user in city' do
      event_a = create(:event_faker, date_start: Date.current - 3, date_finish: Date.current + 10)
        allow(event_a).to receive(:place).and_return(create(:place_faker))
      event_b = create(:event_faker, date_start: Date.current - 3, date_finish: Date.current + 10)
        allow(event_b).to receive(:place).and_return(create(:place_faker))
      event_c = create(:event_faker, date_start: Date.current - 30, date_finish: Date.current + -3)
        allow(event_c).to receive(:place).and_return(create(:place_faker))

        allow(Event).to receive(:all_today).and_return([event_a, event_b, event_c])

      visit ('/newsfeed')

      expect(page).to have_content(event_a.name[0..10])
      expect(page).to have_content(event_b.name[0..10])
      expect(page).should_not have_content(event_c.name[0..10])
    end

    it 'do not display the text to user do login' do
      visit ('/newsfeed')

      expect(page).should_not have_content('Entrar ou criar conta')
    end
  end

  after(:all) do
    I18n.locale = :en
  end

end

