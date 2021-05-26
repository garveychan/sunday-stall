class ProductsController < ApplicationController
  load_resource :stall, only: %i[show new create]
  load_resource through: :stall, only: %i[show edit delete]

  def index
  end

  def show
  end

  def new
    @product = Product.new
    @product_categories = ProductCategory.all.map { |p| [p.name, p.id] }
  end

  def create
    @product = Product.new(product_params)

    # Assign stall to new product and set its status to active by default.
    @product[:stall_id], @product[:active] = params[:stall_id], true

    # Redirect browser to new product if successful.
    # Send user back to form if issue has occurred - likely a Model validation failing.
    # This should not occur in most cases as Views have been constructed with validation too.
    # Each response will send a 'flash' message for the notification component to render.
    # See notification component for more information.
    respond_to do |format|
      if @product.save
        flash[:success] = 'Your product was created successfully!'
        format.html { redirect_to stall_product_path(@stall, @product) }
      else
        flash[:error] = @product.errors.full_messages
        format.html { redirect_to new_stall_product_path }
      end
    end
  end

  def edit
    raise current_user.inspect
    @product = Product.find(id: params[:id])
    @stall = Stall.find(id: params[:stall_id])
    if cannot? :edit, @product
      flash[:error] = "You don't have permission to do that."
      redirect_to stall_product_path(@stall, @product)
    end
  end

  def update
  end

  def delete
  end

  private
  # Leverage 'strong parameters' to defend against malicious attacks.
  # This only allows specific parameters to be accepted from the browser request.
  def product_params
    params.require(:product).permit(:name, :description, :product_category_id, :unit_price, :stock_level, :image)
  end
end
