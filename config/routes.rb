Rails.application.routes.draw do
  root 'home#index'

  devise_for :users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  resources :stalls do
    resources :products, except: :index
    get 'search', on: :collection
  end

  get '/favourites', to: 'favourites#index', as: 'favourites'
  post '/stalls/:id/favourite', to: 'favourites#create', as: 'add_favourite_stall'
  delete '/stalls/:id/favourite', to: 'favourites#destroy', as: 'remove_favourite_stall'
  post '/stalls/:stall_id/products/:id/favourite', to: 'favourites#create', as: 'add_favourite_product'
  delete '/stalls/:stall_id/products/:id/favourite', to: 'favourites#destroy', as: 'remove_favourite_product'
end