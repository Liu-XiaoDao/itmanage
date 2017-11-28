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
  get '/ajaxgetuser' => 'departments#departmentusers'
  get '/devices/batchadd' => 'devices#batchadd'
  post '/devices/batchcreate' => 'devices#batchcreate'

  resources :decategorys
  post '/decategorys/editdecategorycode' => 'decategorys#editdecategorycode'
  post '/decategorys/addchildcategory' => 'decategorys#addchildcategory'



  get '/devices/search' => 'devices#search'

  resources :devices do
    post 'assigndevise', on: :member
    post 'appendpart', on: :member
    get  'recycle', on: :member
    post 'setstatus', on: :member
    post 'showupdate', on: :member   #在show页面的修改
  end
  post '/devices/editdeviceassetname' => 'devices#editdeviceassetname'
  post '/devices/editdeviceservicesn' => 'devices#editdeviceservicesn'
  post '/devices/editdeviceassetdetails' => 'devices#editdeviceassetdetails'
  


  resources :departments


  get 'users/search' => 'users#search'
  resources :users do
  	post 'upload_avatar', on: :member
  	post 'updatepw', on: :member
    post 'assigndevise', on: :member
    post 'assignconsumable', on: :member
  end

  #设备服务路由
  resources :deviceservices do
    post 'upload_img', on: :member
  end

  #其他服务路由
  resources :otherservices do
    post 'upload_img', on: :member
  end

  #耗材路由
  resources :consumables do
    get 'addstocknew', on: :member
    post 'addstock', on: :member
    get 'records', on: :collection
  end

  get 'logs/search' => 'logs#search'
  resources :logs

  #配件路由
  get '/parts/batchadd' => 'parts#batchadd'
  post '/parts/batchcreate' => 'parts#batchcreate'
  get '/parts/search' => 'parts#search'
  get '/ajaxgetpart' => 'parts#ajaxgetpart'
  resources :parts do
    post 'attachdevice', on: :member
  end

  #配件分类路由
  resources :partcategorys do
    post 'editpartcategorycode', on: :collection
    post 'addchildcategory', on: :member
  end


end
