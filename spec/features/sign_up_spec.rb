require 'rails_helper'

feature 'Sign Up' do
  let(:email)    { Faker::Internet.email       }
  let(:password) { Faker::Internet.password(8) }

  scenario 'works w/ valid email' do
    visit rails_authentication_engine.new_sign_up_email_path
    fill_in :email, with: email
    click_button 'Submit'
    open_email(email)
    current_email.click_link("click here")
    fill_in :password, with: password
    click_button 'Submit'
  end
end
