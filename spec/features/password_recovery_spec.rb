require 'rails_helper'

feature 'Sign Up' do
  let(:email)        { user.email                                 }
  let(:new_password) { Faker::Internet.password(8)                }
  let(:user)         { Fabricate(:user, password: "old password") }

  scenario 'logs user in' do
    visit rails_authentication_engine.new_password_recovery_email_path
    fill_in :email, with: email
    click_button 'Submit'
    open_email(email)
    current_email.click_link('click here')
    fill_in :password, with: new_password
    click_button 'Submit'
    expect(current_path).to eq(main_app.root_path)
    expect(page.body).to have_content(I18n.t('rails_authentication_engine.password_recovery.success'))
    expect(page.body).to have_content('it works!')
  end
end
