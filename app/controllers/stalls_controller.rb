class StallsController < ApplicationController
  before_action :check_user_stall, only: %i[new create]
  before_action :set_stall, only: %i[show edit update destroy]
  skip_before_action :authenticate_user!, only: %i[index show]

  # Eager loading to prevent N+1 database queries when rendering cards on stalls index page.
  # Note this eager loads image blobs via the image_attachment association with the Stall model.
  def index
    @stalls = Stall.includes([image_attachment: :blob]).all
  end

  # Render standard show response
  def show
  end

  # Create an empty Stall object and assign it to the instance variable so the creation form can be generated.
  # Build Keywords association in preparation for the form as well.
  def new
    @stall = Stall.new
    @stall.keywords.build
  end

  # Build a new stall object with params received from new stall form.
  # Stall accepts nested attributes for Keywords with which it has a HABTM relationship.
  # Keywords are accepted as a string so it must be parsed before each term is persisted.
  # As such, keywords are excluded from Stall creation and extracted individually.
  # Keywords are set to lower case and checked against the existing database records.
  # If it doesn't exist, it will create it - otherwise it caches the existing record.
  # The << action helps generate the HABTM join table entry to connect the stall with the keyword.
  def create
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

  # Check that the User is authorised to access the edit form with CanCanCan policy - see ability.rb for more information.
  # Redirect to current stall via 'show' action to override edit form response.
  # This protects the endpoint from manual URL requests.
  def edit
    if cannot? :edit, @stall
      flash[:error] = "You don't have permission to do that."
      redirect_to @stall
    end
  end

  # Perform User authorisation based on CanCanCan policy.
  # If an image has been included in the parameters, remove the existing attached image and replace it.
  # Respond to PUT/PATCH request by attempting to persist new parameters for the stall to the database.
  # Redirect to the stall page if successful, otherwise redirect to edit form with error messages.
  def update
    if can? :update, @stall
      respond_to do |format|
        if @stall.update(stall_params)
          if stall_params[:image]
            @stall.image.purge
            @stall.image.attach(stall_params[:image])
          end
          flash[:success] = 'Your changes have been made!'
          format.html { redirect_to @stall }
        else
          flash[:error] = @stall.errors.full_messages
          format.html { redirect_to edit_stall_path }
        end
      end
    else
      flash[:error] = "You don't have permission to do that."
      redirect_to @stall 
    end
  end
  
  # Ensure User has permission to destroy the Stall record.
  # Attempt to destroy the record and redirect to landing page if successful.
  # The destroy method will delete the Stall record and any dependents as described by its model.
  # 
  def destroy
    if can? :destroy, @stall
      if @stall.destroy
        respond_to do |format|
          flash[:alert] = ['Your stall has been deleted.','Hope to see you again soon!']
          format.html { redirect_to root_path }
        end
      end
    else
      flash[:error] = "You don't have permission to do that."
      redirect_to @stall 
    end
  end

  private

  # Look for an associated stall record with id specified by the parameters.
  # Assign the record to an instance method for the View to access.
  def set_stall
    @stall = Stall.find(params[:id])
  end

  # Send alert and redirect to existing stall.
  def existing_stall_redirect
    flash[:alert] = 'You already have a stall!'
    redirect_to @stall
  end

  # Check if the current user has a stall and assign to instance variable and redirect from action.
  def check_user_stall
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
