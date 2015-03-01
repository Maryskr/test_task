Rails.application.routes.draw do
  root 'main#index'

  resources :comment, only: [:index, :create, :update]
end
