class AuthorizationMailer < ActionMailer::Base
  default from: 'support@example.com'

  def send_confirmation(authorization)
    @authorization = authorization
    mail(to: authorization.user.email,
         subject: "#{authorization.provider.capitalize} authorization. Email confirmaion")
  end
end
