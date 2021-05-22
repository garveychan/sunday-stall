class UserMailer < ApplicationMailer
  default from: 'hello@sundaystall.com'

  def send_welcome_email(user)
    @user = user
    mail(:to => @user.email, :subject => "Welcome, #{@user.first_name}!" )
  end
end
