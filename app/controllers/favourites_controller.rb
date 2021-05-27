class FavouritesController < ApplicationController
  # Hook to set relevant favourite record using private method
  # prior to entering a POST or DELETE action.
  before_action :set_favourite, only: %i[create destroy]

  # Index page for User Favourites
  # Assign favourite stalls and products using scoped models to instance variables for View to render.
  # Eager load attached images to prevent querying database for each individual instance.
  # If favourites don't exist, redirect to specialised no favourites page.
  def index
    @favourite_stalls = Stall.favourites(current_user).with_attached_image
    @favourite_products = Product.favourites(current_user).with_attached_image
    if (@favourite_stalls + @favourite_products).empty?
      @stalls = Stall.with_attached_image.all
      render :none
    end
  end

  # POST method to create a Favourite record
  # Custom error messages routed through JavaScript notification
  def create
    if can? :create, @favourite
      if @favourite.save
        flash[:success] = 'Favourited!'
      else
        flash[:error] = 'Sorry, something went wrong.'
      end
    else
      flash[:error] = "You don't have permission to do that."
    end
    redirect
  end
  
  # DELETE method to destroy a Favourite record
  # Custom error messages routed through JavaScript notification
  def destroy
    if can? :destroy, @favourite
      if @favourite.destroy
        flash[:alert] = ['Sorry to see you go!',
                         "Let us know if there's anything we can do better."]
      else
        flash[:error] = 'Sorry, something went wrong.'
      end
    else
        flash[:error] = "You don't have permission to do that."
    end
    redirect
  end

  private
  # Boolean check if User is on a Stall or Product page based on parameters returned
  def product_page?
    params[:stall_id]
  end

  # Redirect based on whether a Stall or Product has just been favourited
  def redirect
    product_page? ? (redirect_to stall_product_path) : (redirect_to stall_path)
  end

  # Set the current stall using the stall id parameter
  def set_favouriteable
    if product_page?
      @favouriteable ||= Product.find_by(id: params[:id])
      @type = :products
    else
      @favouriteable ||= Stall.find_by(id: params[:id])
      @type = :stalls
    end
  end

  # Hook before action to check if stall or product has been favourited.
  # If not, initialize a blank object for the current user and set constant type with the correct format.
  def set_favourite
    set_favouriteable
    if check_favourite(@type).include? @favouriteable
      @favourite = Favourite.send(@type).for_user(current_user).for_object(@favouriteable).first
    else
      @favourite = Favourite.new(favouriteable: @favouriteable, user_id: current_user.id)
      @favourite[:favouriteable_type] = @favourite[:favouriteable_type].camelize
    end
  end
end
