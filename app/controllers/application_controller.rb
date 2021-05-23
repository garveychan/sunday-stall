class ApplicationController < ActionController::Base
  before_action :search?
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def search?
    redirect_to stalls_path if params[:search]
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name date_of_birth phone_number address])
  end
end
