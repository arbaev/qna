Rails.application.routes.draw do
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
  end

  resources :attachments, only: :destroy
  resources :users, only: :show

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end
      resources :questions, only: %i[index show create], shallow: true do
        resources :answers, only: %i[index show]
      end
    end
  end
end
