Rails.application.routes.draw do
  resources :remarks, only: [:index, :create]
  get "/login", to: redirect('/')
end
