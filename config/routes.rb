Rails.application.routes.draw do
  root 'home#index'

  devise_for :users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  resources :stalls do
    resources :products
  end

  get 'stalls/search', to: 'stalls#search', as: 'search'
end