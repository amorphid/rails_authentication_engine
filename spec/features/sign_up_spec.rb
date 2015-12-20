require 'rails_helper'

feature 'Sign Up' do
  let(:email) { Faker::Internet.email }

  scenario 'works w/ valid email' do
    visit rails_authentication_engine.new_sign_up_email_path
    fill_in :email, with: email
    click_button 'Submit'
    open_email(email)
    current_email.click_link("click here")
  end
end
