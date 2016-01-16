require 'rails_helper'

feature 'Sign In' do
  given(:user) { Fabricate(:user) }

  context 'w/ valid email and password' do
    scenario 'takse user who visited sign in path to root path' do
      visit rails_authentication_engine.new_sign_in_path
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
  end

  context 'w/ valid email & password' do
    scenario 'takes user to page' do
      visit pagey_mc_page_path
      fill_in :email, with: user.email
      fill_in :password, with: user.password
      click_button 'Submit'
      expect(page.body).to have_content('Pagey McPage')
    end
  end
end
