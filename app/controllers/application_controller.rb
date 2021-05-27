class ApplicationController < ActionController::Base
  # Hooks to call methods before any action performed in this controller
  # AND all its child controllers - most of the controllers in the application.
  # Mainly to look for a search request from the navigation bar on every page,
  # authenticate user requests as necessary, configure permitted parameters for devise.
  before_action :search_request?
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  # Check if a favourite exists for the model passed in as an argument.
  # Used on either a Stall page or Product page to find a relation between
  # the stall or product with the current user.
  # It takes in a symbol :stall or :product with the 'send' method so that it can be used interchangeably.
  def check_favourite(model)
    Favourite.includes([:favouriteable]).send(model).for_user(current_user).map(&:favouriteable)
  end

  # Redirect to stalls#search action if search parameters detected.
  # Search parameters are passed as a flash for stalls#search to process.
  def search_request?
    redirect_to search_stalls_path, flash: { search: params[:search] } if params[:search]
  end

  # Add extra parameters to devise's sanitizer so further user details
  # can be persisted via the registration page.
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name date_of_birth phone_number])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name date_of_birth phone_number])
  end
end
