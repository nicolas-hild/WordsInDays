Rails.application.routes.draw do
  resources :words, only: [:show, :new, :create] do
    resources :answers, only: [:new, :create]
  end
  root to: "words#show"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
