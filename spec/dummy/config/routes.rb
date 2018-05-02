Rails.application.routes.draw do

  get 'appointments/index'

  resources :patients
  resources :physicians
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
