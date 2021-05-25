class FavouritesController < ApplicationController
  before_action :set_favourite, only: %i[create destroy]

  def index
    @favourite_stalls = get_favourite(:stalls)
    @favourite_products = get_favourite(:products)
    if (@favourite_stalls + @favourite_products).empty?
      @stalls = Stall.includes([image_attachment: :blob]).all
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
      redirect_to stall_path
    end
  end

  def destroy
    if can? :destroy, @favourite
      if @favourite.destroy
        flash[:alert] = ["Sorry to see you go!","Let us know if there's anything we can do beter."]
      else
        flash[:error] = 'Sorry, something went wrong.'
      end  
      redirect_to stall_path
    end
  end

  private
  def set_stall
    @stall ||= Stall.find_by(id: params[:id])
  end

  def set_favourite
    set_stall
    if check_favourite(:stalls).include? @stall
      @favourite = Favourite.find_by(user_id: current_user.id)
    else
      @favourite = Favourite.new(favouriteable: @stall, user_id: current_user.id)
      @favourite[:favouriteable_type] = @favourite[:favouriteable_type].camelize
    end
  end
end