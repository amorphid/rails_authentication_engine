require 'rails_helper'

feature 'Sign In' do
  given(:user) { Fabricate(:user) }

  scenario 'takes used to root page w/ valid email & password' do
    visit rails_authentication_engine.new_sign_in_path
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_button 'Submit'
    expect(current_path).to eq(root_path)
    expect(page.body).to have_content('You are now logged in.  Exciting!')
    expect(page.body).to have_content('it works!')
  end
end
