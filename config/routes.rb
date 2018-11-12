Rails.application.routes.draw do
  get 'franchise/index'

  get 'franchise/show'

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'

  resources :sessions, only: [:create, :destroy]
  resources :home do
  	get :index, :on => :collection
  	get :contact, :on => :collection
    get :login, :on => :collection
    get :about, :on => :collection
    get :add_school, :on => :collection
    post :create_school, :on => :collection
  end

  root to: "franchise#show"
end
