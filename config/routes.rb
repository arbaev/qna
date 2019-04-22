Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  resources :questions do
    resources :answers, shallow: true, only: %i[new create update destroy] do
      patch :best, on: :member
    end
  end
end
