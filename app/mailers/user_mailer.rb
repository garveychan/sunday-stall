class UserMailer < ApplicationMailer
  default from: 'postmaster@sandboxec6f9b2981cf4e7a8349c0d1fd4fd703.mailgun.org'

  def send_welcome_email(user)
    @user = user
    mail(:to => @user.email, :subject => "Welcome, #{@user.first_name}!" )
  end
end
