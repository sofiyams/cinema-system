Rails.application.routes.draw do
  resources :movies do 
    resources :showtimes, except: [:show]
    resources :bookings, only: [:create, :new, :destroy] do 
      member do 
        get :seats
        get :confirm
        patch :seats, action: :save_seats
      end
    end
  end 

  resources :payments, only: [:new] do
    collection do
      get :success
      get :cancel
    end
  end
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'cinema#home'
  get 'about', to: 'cinema#about'
  get 'movies', to: 'cinema#movies'

  get 'signup', to: 'users#new'
  resources :users, except: [:new] do
    resources :bookings, only: [:index, :show]
  end 

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'


end
