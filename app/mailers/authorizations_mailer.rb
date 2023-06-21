class AuthorizationsMailer < ApplicationMailer
  def email_confirmation(authorization)
    @email = authorization.user.email
    @token = authorization.confirmation_token
    @authorization_id = authorization.id
    mail to: @email
  end
end
