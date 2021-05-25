class UsersController < ApplicationController
  after_action :welcome_email, only: %i[create]

  def create
  end
  
  private

  def welcome_email
    UserMailer.send_welcome_email(self).deliver_later
  end
end
