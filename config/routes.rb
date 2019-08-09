require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda {|u| u.admin?} do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  concern :votable do
    post :vote_up, :vote_down, on: :member
  end

  concern :commentable do
    resources :comments, only: %i[create]
  end

  devise_for :users, controllers: {
    omniauth_callbacks: 'oauth_callbacks',
    confirmations: 'oauth_confirmations'
  }

  root to: "questions#index"

  resources :questions,
            shallow: true,
            concerns: %i[votable commentable] do
    resources :answers,
              only: %i[new create update destroy],
              concerns: %i[votable commentable] do
      patch :best, on: :member
    end
    resources :subscriptions, only: %i[create destroy]
  end

  resources :attachments, only: :destroy
  resources :users, only: :show

  get :search, to: 'search#results'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end
      resources :questions, except: %i[new edit], shallow: true do
        resources :answers, except: %i[new edit]
      end
    end
  end
end
