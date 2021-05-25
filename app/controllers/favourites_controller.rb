class FavouritesController < ApplicationController
  def index
    @favourite_stalls = get_favourite(:stalls)
    @favourite_products = get_favourite(:products)
    if (@favourite_stalls + @favourite_products).empty?
      @stalls = Stall.includes([image_attachment: :blob]).all
      render :none
    end
  end

  def create
  end

  def destroy
  end
end