require 'rails_helper'


describe 'See my schedule Events', js: true do

  before(:each) do
    create(:persona_faker)
    create(:city_faker, launch: true)
  end

  context 'when user is logged' do
    before(:each) do
      @user = create(:user, invited: true)
      login_as(@user, :scope => :user)
    end

    it 'show only 2 events agended' do
      event_a = create(:event, name: 'First Event scheduled', date_start: Date.current - 3, date_finish: Date.current + 10)
        allow(event_a).to receive(:place).and_return(create(:place_faker))
      event_b = create(:event, name: 'Second Event scheduled', date_start: Date.current - 3, date_finish: Date.current + 10)
        allow(event_b).to receive(:place).and_return(create(:place_faker))
      create(:event, name: 'Event unscheduled', date_start: Date.current - 3, date_finish: Date.current + 10)

      @user.agendas << Agenda.new(item_id: event_a.id, user_id: @user.id)
      @user.agendas << Agenda.new(item_id: event_b.id, user_id: @user.id)

      visit("/en/users/#{@user.username}/agenda")

      expect(page).to have_content('First Event scheduled')
      expect(page).to have_content('Second Event scheduled')
      expect(page).not_to have_content('Event unscheduled')
    end
  end




end

