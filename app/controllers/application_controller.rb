class ApplicationController < ActionController::Base
  before_action :search_request?
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  
  # Redirect to stalls#search action if search parameters detected.
  # Search parameters are passed as a flash for stalls#search to process.
  def search_request?
      redirect_to search_stalls_path, flash: { search: params[:search] }  if params[:search]
  end

  #########################################################
   # Fetching Polymorphic Favourites (Stalls and Products)
  #########################################################
  # The methods below leverage polymorphic associations and eager loading to quickly
  # present an instance variable carrying specified objects for rendering.
  # Step-by-step:
  # 1. (.includes) - All associated Stalls/Products are eager loaded using the 'favouriteable' association.
  # 2. (.stalls) - Select all Favourite records pertaining to Stalls based on scope proc defined in the model.
  # 3. (.for_user) - The Favourite records pertaining to Stalls are filtered by user_id,
  # 3. cont. - matching the current_user passed through as an argument.
  # 4. (.includes) - Stalls and their Active Storage attachments/blobs are eager loaded via a nested 'includes' method.
  # 5. (.map) - The Favourite records are used to fetch their corresponding Stalls and returned as an array.
  # These arrays are assigned to instance variables and picked up by the View for rendering
  # Additional check methods defined for status inspecting - no attachments loaded.
  def get_favourite_stalls
    Favourite.includes([:favouriteable]).stalls.for_user(current_user)
              .includes(:favouriteable, { favouriteable: { image_attachment: :blob } })
              .map(&:favouriteable)
  end

  def get_favourite_products
    Favourite.includes([:favouriteable]).products.for_user(current_user)
             .includes(:favouriteable, { favouriteable: { image_attachment: :blob } })
             .map(&:favouriteable)
  end

  def check_favourite_stalls
    Favourite.includes([:favouriteable]).stalls.for_user(current_user).map(&:favouriteable)
  end

  def check_favourite_products
    Favourite.includes([:favouriteable]).products.for_user(current_user).map(&:favouriteable)
  end
  # Refactor

  # Add extra parameters to devise's sanitizer so further user details
  # can be persisted via the registration page.
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name date_of_birth phone_number])
  end
end
