class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    ##################################
    # Random Sampling Querying
    ##################################
    # Stalls and Products are randomly chosen from the database for the landing page.
    # `Stall.all.sample` would be the more elegant approach but far less efficient and memory exhaustive.
    # This is because all records would be loaded with their attachments before being sampled with a Ruby method.
    # Instead, we 'pluck' all IDs from the Tables and sample that one attribute instead.
    # Then we pull the 3 + 8 records from the database using the sampled IDs.
    # `Stall.limit(3).order("RANDOM()")` could leverage postgresql functionality to provide random records.
    # However, it has been tested and does not work well with larger databases.
    # We also use eager loading to prevent N+1 database queries when call images for the cards.
    # Note that image blobs are eager loaded via the image_attachment association.
    # Products' stalls are also eager loaded for nested resource routing.
    stall_ids = Stall.pluck(:id).sample(3)
    @stalls = Stall.includes([image_attachment: :blob]).where(id: stall_ids)
    product_ids = Product.pluck(:id).sample(8)
    @products = Product.includes([:stall, image_attachment: :blob]).where(id: product_ids)
  end
end
