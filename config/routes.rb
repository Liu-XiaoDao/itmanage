Rails.application.routes.draw do
  



  root 'home#index'

  get '/welcome/index' => 'welcome#index'
  post '/welcome#index' => 'welcome#index'
  
  get '/signup' => 'accounts#new'
  post '/signup' => 'accounts#create'

  get '/signin' => 'sessions#new'
  post '/signin' => 'sessions#create'
  delete '/signout' => 'sessions#destroy'

  get '/ajaxgetdevice' => 'devices#ajaxgetdevice'

  resources :decategorys
  resources :devices
  resources :departments
  get 'users/search' => 'users#search'
  resources :users do
  	post 'upload_avatar', on: :member
  	post 'updatepw', on: :member
  end  





end
