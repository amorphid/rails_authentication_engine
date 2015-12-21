require 'rails_helper'

feature 'Sign Up' do
  let(:email)    { Faker::Internet.email       }
  let(:password) { Faker::Internet.password(8) }

  scenario 'logs user in' do
    visit rails_authentication_engine.new_sign_up_email_path
    fill_in :email, with: email
    click_button 'Submit'
    open_email(email)
    current_email.click_link('click here')
    fill_in :password, with: password
    click_button 'Submit'
    expect(current_path).to eq(root_path)
    expect(page.body).to have_content('Password set successfully.  You are now logged in.  Woot!')
    expect(page.body).to have_content('it works!')
  end
end
