Rails.application.routes.draw do
  root "home#index"

  devise_for :users
  mount RailsAdmin::Engine => "/admin", as: "rails_admin"

  resources :stalls do
    resources :products
  end

  get "/favourites", to: "favourites#index", as: "favourites"
  post "/stalls/:id", to: "favourites#create", as: "new_favourite_stall"
  delete "/stalls/:id", to: "favourites#destroy", as: "delete_favourite_stall"
  post "/stalls/:stall_id/products/:id", to: "favourites#create", as: "new_favourite_product"
  delete "/stalls/:stall_id/products/:id", to: "favourites#destroy", as: "delete_favourite_product"
end