require 'rails_helper'

feature 'Edit my Account' do

  context 'when user is logged' do
    background(:each) do
      @user = create(:user, invited: true)
      login_as(@user, :scope => :user)

      create(:persona, name: 'Actor')

      visit("pt-BR/user/#{@user.id}/account")
    end

    scenario 'should edit the information about my account' do
      within('#edit-user') do
        fill_in 'Nome completo', with: 'Stuart Little'
        fill_in 'Nome de usuário', with: 'stuart-little-jr'
        fill_in 'Email', with: 'otheremail@gmail.com'
        uncheck 'Entrepreneur'
          check 'Actor'
        fill_in 'Endereço', with: 'Rua Rivadavia Correia 08 - Partenon'
      end

      click_button 'Salvar alterações'

      expect(find_field('Nome completo').value).to eq 'Stuart Little'
      expect(find_field('Nome de usuário').value).to eq 'stuart-little-jr'
      expect(find_field('Email').value).to eq 'otheremail@gmail.com'
      expect(page.has_checked_field?('Actor')).to be_truthy
      expect(find_field('Endereço').value).to eq 'Rua Rivadavia Correia 08 - Partenon'
    end

  end

end

