Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  scope module: :front do
    root "static_pages#home"
  end

  namespace :admin do
    get '/', to: 'dashboard#index'
  end
end
