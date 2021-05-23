class ApplicationController < ActionController::Base
  before_action :search?
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  
  protected
  ######################################
  # Search Feature
  ######################################
  # Using universal callback via Application Controller,
  # the search function can be performed anywhere on the website with the navigation bar.
  # If any request contains a 'search' parameter,
  # then the application recognises that a search has been recognised.
  # It then sets a range of 'stalls' as an instance variable for the universal 'stall' card partial to be rendered.
  # This helps keep the partial DRY.
  # The relevant stalls are then eager loaded along with their image blobs, and filtered by the search parameters.
  # The has_and_belongs_to_many relationship with the keyword database is leveraged to find relevant stalls.
  # The stall index page is then rendered, not redirected.
  # Tha allows this controller action to pass its instance variable to the view instead of stall controller showing all.

  def search?
    if params[:search]
      @stalls = Stall.includes(image_attachment: :blob).joins(:keywords).where( keywords: { term: params[:search].downcase } )
      render "stalls/index" 
    end
  end
  #####################################

  # Add extra parameters to devise's sanitizer so further user details
  # can be persisted via the registration page.
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name date_of_birth phone_number])
  end
end
