Rails.application.routes.draw do
  root to: 'static_pages#home'
  get '/help',                  to: 'static_pages#help'
  get '/about',                 to: 'static_pages#about'
  get '/password_reset_sent',   to: 'static_pages#password_reset_sent'

  get '/signup',                to: 'users#new'
  post '/signup',                to: 'users#create'
  get '/settings/profile/:id',  to: 'users#edit',  as: :edit_profile
  patch '/settings/profile/:id',  to: 'users#update', as: :update_profile
  resources :users, only: [:index, :destroy] do
    resources :masquerades, only: [:new]
  end

  get '/endmasquerade', to: 'masquerades#destroy', via: :delete

  get '/signin',                to: 'sessions#new'
  post '/signin',                to: 'sessions#create'
  match '/signout',               to: 'sessions#destroy', via: :delete

  resources :dashboard, only: [:show]
  resources :appointments, only: [:new, :create, :edit, :update, :destroy, :index]
  resources :events, only: [:index]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :touches, only: [:index, :new, :create, :edit, :update, :destroy], path: '/contact_me'

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
end
