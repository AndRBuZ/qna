Rails.application.routes.draw do
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
  end

  resources :authorizations, only: [:create, :new] do
    get 'email_confirmation/:confirmation_token', action: :email_confirmation, as: :email_confirmation
  end

  resources :files, only: :destroy
  resources :links, only: :destroy
  resources :awards, only: :index

  mount ActionCable.server => '/cable'
end
