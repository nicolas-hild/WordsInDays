Rails.application.routes.draw do
  get 'answers/index'
  get 'words/show'
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
