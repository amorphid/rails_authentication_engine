require 'rails_helper'

feature 'Sign In' do
  given(:user) { Fabricate(:user) }

  context 'w/ valid email and password' do
    scenario 'takse user who visited sign in path to root path' do
      visit rails_authentication_engine.new_sign_in_path
      expect(page.body).not_to have_css('.alert-danger')
      fill_in :email, with: user.email
      fill_in :password, with: user.password
      click_button 'Submit'
      expect(current_path).to eq(main_app.root_path)
    end

    scenario 'takse user who visited root path to root page' do
      visit main_app.root_path
      within('.alert-danger') do
        expect(page.body)
        .to have_content(t('rails_authentication_engine.authentication.sign_in_required'))
      end
      fill_in :email, with: user.email
      fill_in :password, with: user.password
      click_button 'Submit'
      expect(current_path).to eq(main_app.root_path)
    end

    scenario 'takes user who visited pagey_mc_page_path to pagey_mc_page_path' do
      visit pagey_mc_page_path
      within('.alert-danger') do
        expect(page.body)
        .to have_content(t('rails_authentication_engine.authentication.sign_in_required'))
      end
      fill_in :email, with: user.email
      fill_in :password, with: user.password
      click_button 'Submit'
      expect(current_path).to eq(main_app.pagey_mc_page_path)
    end
  end

  context 'w/ invalid email' do
    scenario 'enables user to follow link to start sign up process' do
      visit rails_authentication_engine.new_sign_in_path
      fill_in :email, with: Faker::Internet.email
      fill_in :password, with: user.password
      click_button 'Submit'
      within('.alert-danger') do
        click_link('here')
      end
      expect(current_path).to eq(rails_authentication_engine.new_sign_up_email_path)
    end

    scenario 'enables user to follow link to start sign up process' do
      visit rails_authentication_engine.new_sign_in_path
      fill_in :email, with:    user.email
      fill_in :password, with: Faker::Internet.password
      click_button 'Submit'
      within('.alert-danger') do
        click_link('here')
      end
      expect(current_path).to eq(rails_authentication_engine.new_password_recovery_email_path)
    end
  end
end
