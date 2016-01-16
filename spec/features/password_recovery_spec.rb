require 'rails_helper'

feature 'Password Recovery' do
  context 'existing user' do
    let(:new_password) { Faker::Internet.password(8)                }
    let(:old_password) { "old password" }
    let(:user)         { Fabricate(:user, password: old_password) }

    before do
      visit rails_authentication_engine.new_password_recovery_email_path
      fill_in :email, with: user.email
      click_button('Submit')
      open_email(user.email)
      current_email.click_link('click here')
      expect(page.body).not_to have_css('.alert-info')
      fill_in :password, with: new_password
    end

    scenario 'accesses current account' do
      expect { click_button 'Submit' }
      .to change { User.count }
      .by(0)
    end

    scenario 'takes user to root_page' do
      click_button 'Submit'
      expect(current_path).to eq(main_app.root_path)
    end

    scenario 'successfully changes password' do
      click_button 'Submit'
      same_user = User.find(user.id)
      expect(same_user.authenticate(old_password)).to eq(false)
      expect(same_user.authenticate(new_password)).to eq(same_user)
    end
  end

  context 'new user' do
    let(:user) { Fabricate.build(:user) }

    before do
      visit rails_authentication_engine.new_password_recovery_email_path
      fill_in :email, with: user.email
      click_button('Submit')
      open_email(user.email)
      current_email.click_link('click here')
      within('.alert-info') do
        expect(page.body)
        .to have_content(t(
          'rails_authentication_engine.password_recovery.new_user',
          email: user.email
        ))
      end
      fill_in :password, with: user.password
    end

    scenario 'gets a new account' do
      expect { click_button 'Submit' }
      .to change { User.count }
      .from(0)
      .to(1)
    end

    scenario 'takes user to root_page' do
      click_button 'Submit'
      expect(current_path).to eq(main_app.root_path)
    end
  end
end
