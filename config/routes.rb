Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  resources :questions do
    patch :best_answer, on: :member
    resources :answers, shallow: true, only: %i[new create update destroy]
  end
end
