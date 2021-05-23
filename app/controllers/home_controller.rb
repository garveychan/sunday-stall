class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    # Eager loading to prevent N+1 database queries when rendering cards on stalls index page.
    # Note this eager loads image blobs via the image_attachment association with the Stall model.
    @stalls = Stall.includes([image_attachment: :blob]).all
  end
end
