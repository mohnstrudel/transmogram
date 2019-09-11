Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  get 'search/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  scope module: :front do
    root "static_pages#home"

    # Error pages
    get "/404", to: 'errors#not_found'
    get "/422", to: 'errors#unacceptable'
    get "/500", to: 'errors#internal_error'

    scope module: :users do
      devise_for :users
    end
    resources :posts
    match :like, to: 'likes#create', as: :like, via: :post
    match :unlike, to: 'likes#destroy', as: :unlike, via: :post
    resources :comments, only: [:create, :destroy]
    resources :users, only: [:show]

    resources :images
    post 'activate_image/:id', to: 'images#activate', as: :activate
    # match :activate_image, to: :id', as: :activate, via: :post
    # match :delete_image to: 'likes#destroy', as: :unlike, via: :post

    get 'search' => 'search#index'
    get :help, to: 'static_pages#help'
    get :contact, to: 'static_pages#contact'
    get :about, to: 'static_pages#about'
    get :audits, to: 'static_pages#audits'
  end

  namespace :admin do
    get '/', to: 'dashboard#index'
  end
end
