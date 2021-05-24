class UsersController < ApplicationController
  def create
    welcome_email
  end

  private

  def welcome_email
    UserMailer.send_welcome_email(self).deliver_later
  end
end
