Rails.application.routes.draw do
  get 'manual/index'

  resources :customers, shallow: true do
    resources :retailers
    resources :shops
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"
end
