class FavouritesController < ApplicationController
  def index
    @favourite_stalls = get_favourite_stalls
    @favourite_products = get_favourite_products
  end

  def create
  end

  def destroy
  end
end