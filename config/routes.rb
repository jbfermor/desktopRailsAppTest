Rails.application.routes.draw do
  get "column/:id", to: "columns#activate", as: :column_activate
  get "printer/:id", to: "printers#activate", as: :printer_activate
  patch "report/:id", to: "reports#update_filter", as: :report_update_filter
  patch "report/:id", to: "reports#report_create", as: :report_create
  get "report/:id", to: "reports#select_all_printers", as: :select_all_printers
  get "report/:id", to: "reports#deselect_all_printers", as: :deselect_all_printers
  resources :customers, shallow: true do
    resources :retailers
    resources :shops
    resources :reports

  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"
end
