require 'rails_helper'

feature 'Login with email', js: false do

  scenario 'Click in Sign In link' do
    visit '/en'

    click_link 'Sign in'

    expect(page).to have_content('Entrar com email')
  end

end
