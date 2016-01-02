require 'rails_helper'

feature 'Sign In' do
  given(:user) { Fabricate(:user) }

  context 'w/ valid email & password' do
    scenario 'takes user to root page w/ valid email & password' do
      visit root_path
      fill_in :email, with: user.email
      fill_in :password, with: user.password
      click_button 'Submit'
      expect(page.body).to have_content('Rooty McRoot')
    end

    scenario 'takes user to page' do
      visit pagey_mc_page_path
      fill_in :email, with: user.email
      fill_in :password, with: user.password
      click_button 'Submit'
      expect(page.body).to have_content('Pagey McPage')
    end
  end
end
