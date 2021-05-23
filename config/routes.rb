Rails.application.routes.draw do
  root 'home#index'

  devise_for :users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  get 'stalls/search_results', to: 'stalls#search_results', as: 'search_results'

  resources :stalls do
    resources :products
  end

end