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

  devise_for :users, controllers: { registrations: 'users/registrations' }
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
end