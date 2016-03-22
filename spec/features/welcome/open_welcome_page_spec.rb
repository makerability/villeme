require 'rails_helper'

describe 'Open the welcome page', js: true do
  context 'when the locale is in :en' do
    it 'should open the page with english language' do
      visit '/en'

      expect(page).to have_title('Welcome to Villeme - Events and activities in your city')
    end
  end

  context 'when the locale is :pt-BR' do
    it 'should open the welcome page in portuguese language' do
      visit '/pt-BR'

      expect(page).to have_title('Bem-vindo ao Villeme - Eventos e atividades na sua cidade!')
    end
  end
end
