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
    @stall.keywords.build
  end

  def create
    # Build a new stall object with params received from new stall form.
    # Stall accepts nested attributes for Keywords with which it has a HABTM relationship.
    # Keywords are accepted as a string so it must be parsed before each term is persisted.
    # As such, keywords are excluded from Stall creation and extracted individually.
    # Keywords are set to lower case and checked against the existing database records.
    # If it doesn't exist, it will create it - otherwise it caches the existing record.
    # The << action helps generate the HABTM join table entry to connect the stall with the keyword.
    @stall = Stall.new(stall_params.except(:keywords_attributes))
    params.dig(:stall,:keywords_attributes,"0",:term).gsub(',',' ').split.each do |k|
      term = Keyword.find_or_create_by({term: k.downcase})
      @stall.keywords << term
    end

    # Assign stall to current user and set its status to active by default.
    @stall[:user_id], @stall[:active] = current_user.id, true

    # Redirect browser to newly created stall if successful.
    # Send user back to form if issue has occurred - likely a Model validation failing.
    # This should not occur in most cases as Views have been constructed with validation too.
    # Each response will send a 'flash' message for the notification component to render.
    # See notification component for more information.
    respond_to do |format|
      if @stall.save
        flash[:success] = 'Your stall was created successfully!'
        format.html { redirect_to @stall }
      else
        flash[:error] = @stall.errors.full_messages
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
    # Check if the current user has a stall and assign to instance variable and redirect from action.
    if current_user.stall
      @stall = current_user.stall
      existing_stall_redirect
    else
      @stall = nil
    end
  end

  # Leverage 'strong parameters' to defend against malicious attacks.
  # This only allows specific parameters to be accepted from the browser request.
  def stall_params
    params.require(:stall).permit(:title, :subtitle, :description, :image, keywords_attributes: [:term])
  end
end
