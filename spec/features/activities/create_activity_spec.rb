require 'rails_helper'


feature 'Create an activity', js: true do

  context 'when as CURRENT_USER' do

    background(:each) do
      @user = create(:user, invited: true, account_complete: true)
      login_as(@user, :scope => :user)

      @activity_attributes = build_stubbed(:event, type: 'Activity')

      weeks = [["Sunday", 0, 7], ["Monday", 1, 1], ["Tuesday", 2, 2], ["Wednesday", 3, 3,], ["Thursday", 4, 4], ["Friday", 5, 5], ["Saturday", 6, 6]]

      weeks.each do |day|
        week = Week.create(
            name: day[0],
            slug: day[0].downcase,
            binary: day[1],
            organizer_id: day[2]
        )
      end
    end

    scenario 'should open the page with success' do
      visit('/en/activities/new')

      expect(page).to have_content('Criar atividade')
    end

    scenario 'should create an activity' do
      visit('/en/activities/new')

        page.fill_in 'activity[name]', with: @activity_attributes.name
        page.evaluate_script("$('.jqte_editor').text('#{@activity_attributes.description}')")
        page.fill_in 'activity[date_start]', with: Date.current.strftime('%d/%m/%Y')
        page.fill_in 'activity[date_finish]', with: (Date.current + 10).strftime('%d/%m/%Y')

        sleep 3

        page.check 'Monday'
        page.check 'Sunday'
        page.fill_in 'activity[hour_start_first]', with: '09:00'
        page.fill_in 'activity[hour_finish_first]', with: '20:30'
        attach_file 'activity[image]', "#{Rails.root}/public/images/default-event-image.jpg"
        # fill_in '#event_cost_fake', with: '10,00'
        page.fill_in 'activity[place_attributes][name]', with: 'Parque da Redenção'
          find_field('activity[place_attributes][name]').native.send_keys(:return)

        sleep 3

        page.fill_in 'activity[address]', with: @activity_attributes.address


      page.click_button 'Criar atividade'

      sleep 3

      expect(page).to have_css('.EventSingle')
      expect(page).to have_text(@activity_attributes.name)
      expect(page).to have_text(@activity_attributes.description[0..360].html_safe)
      expect(page).to have_text('Parque da Redenção')
      expect(page).to have_text(@activity_attributes.address)
      expect(page).to have_text("#{Date.current.strftime('%d/%m')} - #{(Date.current + 10).strftime('%d/%m')}")
      expect(page).to have_text('09:00h até 20:30h')
    end
  end


end