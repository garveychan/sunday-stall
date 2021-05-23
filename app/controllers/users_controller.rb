class UsersController < ApplicationController
  def create
    welcome_email
    set_default_role
  end

  private

  def welcome_email
    UserMailer.send_welcome_email(self).deliver_later
  end

  def set_default_role
    self.role ||= User.roles[:user]
    save
  end
end
