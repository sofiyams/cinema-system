Rails.application.routes.draw do
  resources :movies
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'cinema#home'
  get 'about', to: 'cinema#about'
  get 'movies', to: 'cinema#movies'

  get 'signup', to: 'users#new'
  resources :users, except: [:new]

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'


end
