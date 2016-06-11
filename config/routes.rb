Rails.application.routes.draw do
  root 'parsers#index'
  resources :parsers, only: [:index, :create]
end
