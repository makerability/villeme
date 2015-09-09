require 'rails_helper'


feature 'See an Event' do

  context 'when as CURRENT_USER' do

    background(:each) do
      @user = create(:user, invited: true, account_complete: true)
              login_as(@user, :scope => :user)
      @place = create(:place)

      @event = create(:event,
                      type: 'Event',
                      user_id: @user.id,
                      place_id: @place.id,
                      date_start: Date.current,
                      date_finish: Date.current + 10,
                      hour_start_first: '09:00h',
                      hour_finish_first: '20:00h'
      )
    end

    scenario 'should open the event page and see basic information' do
      visit("/en/events/#{@event.slug}")

      expect(page).to have_css('.EventSingle')
      expect(page).to have_css('.EventSingle-rating')
      expect(page).to have_text(@event.name)
      expect(page).to have_text(@event.description[0..360].html_safe)
      expect(page).to have_text('09:00h')
      expect(page).to have_text('20:00h')
      expect(page).to have_text('12.00')
      expect(page).to have_text('www.google.com')
      expect(page).to have_text(@event.email)
      expect(page).to have_text(@event.phone)
      expect(page).to have_text(@place.name)
    end

  end


end