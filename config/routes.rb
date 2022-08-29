Rails.application.routes.draw do
 
  get "column/:id", to: "columns#activate", as: :column_activate
  get "printer/:id", to: "printers#activate", as: :printer_activate
  patch "report/:id/update_filter", to: "reports#update_filter", as: :report_update_filter
  patch "report/:id/report_create", to: "reports#report_create", as: :report_create
  get "report/:id/select_all_printers", to: "reports#select_all_printers", as: :select_all_printers
  get "report/:id/print_report", to: "reports#print_report", as: :print_report
  get "report/:id/print_send_report", to: "reports#print_send_report", as: :print_send_report
  post "report/:id/final_sending", to: "reports#final_sending", as: :final_sending

  resources :customers, shallow: true do
    resources :retailers
    resources :reports, shallow: true
  end
  resources :shops


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"
end
