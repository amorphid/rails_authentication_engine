Fabricator(:password_reset, class_name: 'rails_authentication_engine/password_reset') do
  email_confirmation { Fabricate(:email_confirmation) }
end
