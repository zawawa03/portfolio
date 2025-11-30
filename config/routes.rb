Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    passwords: "users/passwords",
    omniauth_callbacks: "users/omniauth_callbacks"
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # email_check_env
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  # check_sidekiq
  require "sidekiq/web"
  mount Sidekiq::Web => "/sidekiq"

  # for_my_app_route
  root "static_page#top"

  resource :setting, only: %i[show]
  get "agreement", to: "settings#agreement", as: "agreement"
  get "plivacy_policy", to: "settings#privacy_policy", as: "plivacy_policy"
  resource :contact, only: %i[show new create]

  resource :profile, only: %i[new create edit update]
  get "profile/:id", to: "profiles#show", as: "user_profile"

  resources :notifications, only: %i[index]

  get "friends/:id", to: "friends#chat_board", as: "friend_chat"
  post "friends/:user_id", to: "friends#create", as: "new_friend"
  put "friends/:id", to: "friends#approve", as: "approve_friend"
  delete "friends/:id", to: "friends#refuse", as: "refuse_friend"
  patch "friend/:user_id", to: "friends#blocked", as: "block_friend"


  resources :rooms, only: %i[new index show create edit update destroy] do
    collection do
      get :search
    end
    member do
      get :chat_board
      delete :leave
    end
    resources :permits, only: %i[create destroy] do
      member do
        post :approve
        delete :refuse
      end
    end
  end

  resources :boards, only: %i[new index show create destroy] do
    collection do
      get :search
    end
    resources :comments, only: %i[create]
  end

  # for_admin_route
  namespace :admin do
    root "dashboards#index"
    resource :dashboard, only: %i[index]
    devise_scope :user do
      get "login", to: "sessions#new"
      post "login", to: "sessions#create"
      delete "logout", to: "sessions#destroy"
      get "user_edit/:id", to: "registrations#edit", as: "user_edit"
      put "user_update/:id", to: "registrations#update", as: "user_update"
      delete "user_destroy/:id", to: "registrations#destroy", as: "user_destroy"
    end
    resources :users, only: %i[index show]
    resources :profiles, only: %i[show edit update]
    resources :rooms, only: %i[index show destroy]
    resources :games, only: %i[index create destroy]
    resources :tags, only: %i[index create destroy]
    resources :contacts, only: %i[index show destroy]
    resources :boards, only: %i[index show destroy] do
      resources :comments, only: %i[destroy]
    end
  end
end
