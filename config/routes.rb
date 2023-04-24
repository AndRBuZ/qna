Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

  resources :questions do
    resources :answers, shallow: true, only: %i[create destroy update] do
      member do
        patch 'best'
      end
    end
  end

  resources :files, only: :destroy
end
