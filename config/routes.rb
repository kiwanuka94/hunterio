Rails.application.routes.draw do
  get 'home/index'
  root 'pages#home'


  devise_for :users
  get 'logout', to: 'pages#logout', as: 'logout'
  get 'api/search_domain', to: 'api#search_domain'
  post 'home/create', to: 'home#create', as: 'home_create'
  post 'update_emails', to: 'home#update_emails'
  post 'create', to: 'export#create'
  get 'export/download', to: 'export#download', as: :export_download





  resources :subscribe, only: [:index]
  resources :dashboard, only: [:index]
  resources :account, only: [:index, :update]
  resources :billing_portal, only: [:create]
  match '/billing_portal' => 'billing_portal#create', via: [:get]
  match '/cancel' => 'billing_portal#destroy', via: [:get]

  # static pages
  pages = %w(
    privacy terms
  )

  pages.each do |page|
    get "/#{page}", to: "pages##{page}", as: "#{page.gsub('-', '_')}"
  end

  # admin panels
  authenticated :user, -> user { user.admin? } do
    namespace :admin do
      resources :dashboard, only: [:index]
      resources :impersonations, only: [:new]
      resources :users, only: [:edit, :update, :destroy]
    end

    # convenience helper
    get 'admin', to: 'admin/dashboard#index'
  end
end
