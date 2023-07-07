require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  root 'questions#index'

  concern :votable do
    member do
      post :upvote
      post :downvote
    end
  end

  concern :commentable do
    resources :comments, shallow: true, only: [:create]
  end

  resources :questions, concerns: %i[votable commentable] do
    resources :answers, shallow: true, only: %i[create destroy update], concerns: %i[votable commentable] do
      member do
        patch 'best'
      end
    end
    resources :subscriptions, only: [:create, :destroy]
  end

  resources :authorizations, only: [:create, :new] do
    get 'email_confirmation/:confirmation_token', action: :email_confirmation, as: :email_confirmation
  end

  resources :files, only: :destroy
  resources :links, only: :destroy
  resources :awards, only: :index

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, only: [:index, :show, :create, :update, :destroy] do
        resources :answers, only: [:index, :show, :create, :update, :destroy]
      end
    end
  end

  mount ActionCable.server => '/cable'
end
