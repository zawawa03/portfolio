Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    passwords: "users/passwords"
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

  # for_my_app_route
  root "static_page#top"
  get "setting", to: "settings#show"

  resource :profile, only: %i[new create edit update]
  get "profile/:id", to: "profiles#show", as: "user_profile"

  resources :rooms, only: %i[new index show create edit update destroy] do
    member do
      get :chat_board
    end
    resources :permits, only: %i[create destroy] do
      member do
        post :approve
        delete :refuse
      end
    end
  end

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
  end
end
