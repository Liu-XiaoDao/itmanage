Rails.application.routes.draw do

  get '/signup' => 'accounts#new'
  post '/signup' => 'accounts#create'
  
  get '/signin' => 'sessions#new'
  post '/signin' => 'sessions#create'
  delete '/signout' => 'sessions#destroy'


  root 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
