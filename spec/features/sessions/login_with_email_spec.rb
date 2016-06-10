require 'rails_helper'

feature 'Login with email', js: true do
  background do
    @city = create(:city)
    @event = create(:event_faker, date_start: Date.current - 3, date_finish: Date.current + 10)
    9.times { create(:event_faker, date_start: Date.current - 3, date_finish: Date.current + 10) }
  end

  context 'using an invite key' do
    background do
      @invite = create(:invite, invited: true, password: 'ahsddakdhkasjhd')
    end

    scenario 'does redirect to newsfeed and see 10 events' do
      visit "?key=#{@invite.key}"

      expect(page).to have_content 'Fazer login'
      expect(page).to have_content 'Email'
      expect(page).to have_content 'Password'

      fill_in 'Email', with: @invite.email
      fill_in 'Password', with: @invite.password
      click_button 'Entrar'

      expect(page).to have_content @event.name
    end
  end

  context 'clicking in direct link' do
    background do
      @user = create(:user)
    end

    scenario 'does redirect to newsfeed and see 10 events' do
      visit '/en'

      click_link 'Sign in'
      click_button 'Login with email'

      expect(page).to have_content 'Fazer login'
      expect(page).to have_content 'Email'
      expect(page).to have_content 'Password'

      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Entrar'

      expect(page).to have_content @event.name
    end
  end

end
