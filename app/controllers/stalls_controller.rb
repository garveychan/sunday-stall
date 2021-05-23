class StallsController < ApplicationController
  before_action :check_user_stall, only: %i[new create]
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    # Eager loading to prevent N+1 database queries when rendering cards on stalls index page.
    # Note this eager loads image blobs via the image_attachment association with the Stall model.
    @stalls = Stall.includes([image_attachment: :blob]).all
  end

  def show; end

  def new
    @stall = Stall.new
  end

  def create
    @stall = Stall.new(stall_params)
    @stall[:user_id], @stall[:active] = current_user.id, true

    respond_to do |format|
      if @stall.save
        flash[:success] = 'Your stall was created successfully!'
        format.html { redirect_to @stall }
      else
        flash[:error] = 'Sorry, something went wrong. Please try again.'
        format.html { redirect_to new_stall_path }
      end
    end
  end

  def edit; end

  def update; end

  def destroy; end

  def search_results
    # @relevant_stalls =
  end

  private

  def existing_stall_redirect
    # Send alert and redirect to existing stall.
    flash[:alert] = 'You already have a stall!'
    redirect_to @stall
  end

  def check_user_stall
    # Check if current user has a stall and assign to instance variable and redirect from action.
    if current_user.stall
      @stall = current_user.stall
      existing_stall_redirect
    else
      @stall = nil
    end
  end

  # Only allow a list of trusted parameters through.
  def stall_params
    params.require(:stall).permit(:title, :subtitle, :description, :image)
  end
end
