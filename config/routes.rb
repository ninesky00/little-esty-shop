Rails.application.routes.draw do
  root "welcome#index"
  resources :merchants do
    member do
      get 'dashboard'
    end
    scope module: "merchants" do
      resources :items, only: :update
      resources :items, except: [:destroy], shallow: true
      resources :invoices, only: [:index, :show]
      resources :invoice_items, only: [:update]
      resources :bulk_discounts
    end
  end

  get '/admin', to: 'admins#dashboard' 
  namespace :admin, shallow: true do 
    resources :merchants
    resources :invoices, only: [:index, :show, :update]
  end
end
