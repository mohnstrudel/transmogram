Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  scope module: :front do
    root "static_pages#home"
    scope module: :users do
      devise_for :users
    end
    resources :posts
    match :like, to: 'likes#create', as: :like, via: :post
    match :unlike, to: 'likes#destroy', as: :unlike, via: :post
    resources :comments, only: [:create, :destroy]
  end

  namespace :admin do
    get '/', to: 'dashboard#index'
  end
end
