Rails.application.routes.draw do
  root 'home#index'
  resources :stalls do
    get 'search', on: :collection
    get 'favourites', to: 'favourites#index', on: :collection
    post 'favourite', to: 'favourites#create', on: :member
    delete 'favourite', to: 'favourites#destroy', on: :member
    resources :products, except: :index do
      post 'favourite', to: 'favourites#create', on: :member
      delete 'favourite', to: 'favourites#destroy', on: :member
    end
  end
  
  # get '/favourites', to: 'favourites#index', as: 'favourites'
  # post '/stalls/:id/favourite', to: 'favourites#create', as: 'add_favourite_stall'
  # delete '/stalls/:id/favourite', to: 'favourites#destroy', as: 'remove_favourite_stall'
  # post '/stalls/:stall_id/products/:id/favourite', to: 'favourites#create', as: 'add_favourite_product'
  # delete '/stalls/:stall_id/products/:id/favourite', to: 'favourites#destroy', as: 'remove_favourite_product'
  
  devise_for :users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
end