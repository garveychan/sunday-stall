class FavouritesController < ApplicationController
  before_action :set_favourite, only: %i[create destroy]

  def index
    @favourite_stalls = Stall.favourites(current_user).with_attached_image
    @favourite_products = Product.favourites(current_user).with_attached_image
    if (@favourite_stalls + @favourite_products).empty?
      @stalls = Stall.with_attached_image.all
      render :none
    end
  end

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
  def product_page?
    params[:stall_id]
  end

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
