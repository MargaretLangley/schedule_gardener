ScheduleGardener::Application.routes.draw do




  root                            to: 'static_pages#home'
  match '/help',                  to: 'static_pages#help'
  match '/about',                 to: 'static_pages#about'
  match '/contact',               to: 'static_pages#contact'
  match '/password_reset_sent',   to: 'static_pages#password_reset_sent'


  match '/signup',                to: 'users#new',    via: :get
  match '/signup',                to: 'users#create', via: :post
  match '/settings/profile/:id',  to: 'users#edit',   via: :get, as: :edit_profile
  match '/settings/profile/:id',  to: 'users#update', via: :put, as: :update_profile
  resources :users, only: [:index,:show,:destroy]


  match '/signin',                to: 'sessions#new',     via: :get
  match '/signin',                to: 'sessions#create',  via: :post
  match '/signout',               to: 'sessions#destroy', via: :delete


  resources :dashboard, only: [:show]
  resources :appointments, only: [:new, :create, :edit, :update, :destroy, :index]
  resources :events , only: [:index]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :touches, only: [:index, :new, :create, :edit, :update, :destroy], path: '/contact_me'

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
end
