class FavouritesController < ApplicationController

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
  # These arrays are assigned to instance variables and picked up by the View for rendering.
  def index
    @favourite_stalls = Favourite.includes([:favouriteable]).stalls.for_user(current_user)
                                 .includes(:favouriteable, { favouriteable: { image_attachment: :blob } })
                                 .map(&:favouriteable)
    @favourite_products = Favourite.includes([:favouriteable]).products.for_user(current_user)
                                   .includes(:favouriteable, { favouriteable: { image_attachment: :blob } })
                                   .map(&:favouriteable)
    render 'favourites/index'
  end

  def create

  end

  def destroy

  end

end