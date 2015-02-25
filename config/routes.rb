Rails.application.routes.draw do
  root 'main#index'

  resource :comment, only: [:index, :create]
end
