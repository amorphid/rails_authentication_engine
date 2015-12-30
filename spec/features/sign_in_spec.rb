require 'rails_helper'

feature 'Sign In' do
  given(:user) { Fabricate(:user) }

  scenario 'takes used to root page w/ valid email & password' do
    visit rails_authentication_engine.new_sign_in_path
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_button 'Submit'
    expect(current_path).to eq(main_app.root_path)
    expect(page.body).to have_content(I18n.t('rails_authentication_engine.flash.successful_sign_in'))
    expect(page.body).to have_content('it works!')
  end
end
