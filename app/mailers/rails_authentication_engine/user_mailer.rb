module RailsAuthenticationEngine
  class UserMailer < ActionMailer::Base
    default from: 'mpope.cr@gmail.com'
    layout 'rails_authentication_engine/mailer'

    def sign_up(email_confirmation)
      @email_confirmation = email_confirmation
      mail(to: @email_confirmation.email, subject: '[Plumhire] Please confirm your email')
    end

    def password_recovery(email_confirmation)
      @email_confirmation = email_confirmation
      mail(to: @email_confirmation.email, subject: '[Plumhire] Your password recovery request has arrived!')
    end
  end
end
