Rails.application.routes.draw do
  get 'products/index'
  get 'products/new'
  get 'products/edit'
  get 'products/show'
  get 'stalls/index'
  get 'stalls/new'
  get 'stalls/edit'
  get 'stalls/show'
  get 'stalls/search'
  root 'home#index'

  devise_for :users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  resources :stalls do
    resources :products
  end

  get 'stalls/search', to: 'stalls#search', as: 'search'
end
