require 'rails_helper'


feature 'See my Account' do

  context 'when user is logged' do
    background(:each) do
      @user = create(:user, invited: true)
      login_as(@user, :scope => :user)
    end

    scenario 'open the account edit with success' do
      visit("pt-BR/user/#{@user.id}/account")

      expect(page).to have_content('Editar conta')
    end

    scenario 'should be see the user name' do
      visit("pt-BR/user/#{@user.id}/account")

      expect(find_field('Nome completo').value).to eq(@user.name)
    end

    scenario 'should be see the user username' do
      visit("pt-BR/user/#{@user.id}/account")

      expect(find_field('Nome de usuário').value).to eq(@user.username)
    end

    scenario 'should be see the user email' do
      visit("pt-BR/user/#{@user.id}/account")

      expect(find_field('Email').value).to eq(@user.email)
    end

    scenario 'should be see the user persona checked' do
      visit("pt-BR/user/#{@user.id}/account")

      expect(page.has_checked_field?('Entrepreneur')).to be_truthy
    end

    scenario 'should be see the user persona address' do
      visit("pt-BR/user/#{@user.id}/account")

      expect(find_field('Endereço').value).to eq(@user.address)
    end
  end




end

