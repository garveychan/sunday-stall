class ProductsController < ApplicationController
  load_resource :stall
  load_resource through: :stall, except: %i[new create]
  before_action :set_product_categories, only: %i[new edit]
  skip_before_action :authenticate_user!, only: %i[show]

  def new
    @product = Product.new(stall_id: params[:stall_id])

    if can? :create, @product
    else
      flash[:error] = "You don't have permission to do that."
      redirect_to stall_path(@stall)
    end
  end
  
  def create
    # Assign stall to new product and set its status to active by default.
    @product = @stall.products.new(product_params)
    @product[:active] = true
    
    # Redirect browser to new product if successful.
    # Send user back to form if issue has occurred - likely a Model validation failing.
    # This should not occur in most cases as Views have been constructed with validation too.
    # Each response will send a 'flash' message for the notification component to render.
    # See notification component for more information.
    if can? :create, @product
      respond_to do |format|
        if @product.save
          flash[:success] = 'Your product was created successfully!'
          format.html { redirect_to stall_product_path(@stall, @product) }
        else
          flash[:error] = @product.errors.full_messages
          format.html { redirect_to new_stall_product_path }
        end
      end
    else
      flash[:error] = "You don't have permission to do that."
      redirect_to stall_path(@stall)
    end 
  end

  def show
    @favourited = true if check_favourite(:products).include? @product
  end

  def edit
    if cannot? :edit, @product
      flash[:error] = "You don't have permission to do that."
      redirect_to stall_product_path(@stall, @product)
    end
  end

  def update
    if can? :update, @product
      respond_to do |format|
        if @product.update(product_params)
          if product_params[:image]
            @product.image.purge
            @product.image.attach(product_params[:image])
          end
          flash[:success] = 'Your changes have been made!'
          format.html { redirect_to stall_product_path(@stall, @product) }
        else
          flash[:error] = @stall.errors.full_messages
          format.html { redirect_to edit_stall_product_path }
        end
      end
    else
      flash[:error] = "You don't have permission to do that."
      redirect_to stall_product_path(@stall, @product)
    end
  end

  # Ensure User has permission to destroy the Stall record.
  # Attempt to destroy the record and redirect to stall page if successful.
  # The destroy method will delete any associations with the product e.g. usre favourites. 
  def destroy
    if can? :destroy, @product
      if @product.destroy
        respond_to do |format|
          flash[:alert] = ['Your product has been deleted.','Hope you add some more soon!']
          format.html { redirect_to @stall }
        end
      end
    else
      flash[:error] = "You don't have permission to do that."
      redirect_to @stall
    end
  end

  private

  # Leverage 'strong parameters' to defend against malicious attacks.
  # This only allows specific parameters to be accepted from the browser request.
  def product_params
    params.require(:product).permit(:name, :description, :product_category_id, :unit_price, :stock_level, :image)
  end

  def set_product_categories
    @product_categories = ProductCategory.all.map { |p| [p.name, p.id] }
  end
end
