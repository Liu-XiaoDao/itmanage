Rails.application.routes.draw do
  

  root 'home#index'

  get '/welcome/index' => 'welcome#index'
  post '/welcome#index' => 'welcome#index'
  
  get '/signup' => 'accounts#new'
  post '/signup' => 'accounts#create'

  get '/signin' => 'sessions#new'
  post '/signin' => 'sessions#create'
  delete '/signout' => 'sessions#destroy'


  resources :devices

  resources :users do
  	post 'upload_avatar', on: :member
  	post 'updatepw', on: :member
  end  





end
