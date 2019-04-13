Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  resources :questions, shallow: true, except: %i[edit update] do
    resources :answers, only: %i[new create destroy]
  end
end
