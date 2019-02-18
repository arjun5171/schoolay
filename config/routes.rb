Rails.application.routes.draw do
  
  namespace :admin do
    resources :users
    resources :app_configs
    resources :franchises

    root to: "users#index"
  end

  resources :franchise do
    get :index, :on => :collection
    get :show, :on => :collection
    get :sales_report , :on => :member
  end

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'

  resources :home do
    get :download_csv, :on => :collection
  	get :index, :on => :collection
  	get :contact, :on => :collection
    get :login, :on => :collection
    get :about, :on => :collection
    get :add_school, :on => :collection
    post :create_school, :on => :collection
  end

  devise_for :users

  root to: "home#index"
end