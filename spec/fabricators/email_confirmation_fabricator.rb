Fabricator(:email_confirmation, class_name: 'rails_authentication_engine/email_confirmation') do
  email { Faker::Internet.email }
end
