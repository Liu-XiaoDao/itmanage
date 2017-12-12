Rails.application.routes.draw do

  #首页
  root 'home#index'
  #刚开始想做首页的现在没用了
  get '/welcome/index' => 'welcome#index'
  post '/welcome#index' => 'welcome#index'

  #获取注册页面和注册
  get '/signup' => 'accounts#new'
  post '/signup' => 'accounts#create'

  #登录的三个:获取登录页,登录,退出登录
  get '/signin' => 'sessions#new'
  post '/signin' => 'sessions#create'
  delete '/signout' => 'sessions#destroy'


  
  #设备分类
  resources :decategorys
  post '/decategorys/editdecategorycode' => 'decategorys#editdecategorycode'
  post '/decategorys/addchildcategory' => 'decategorys#addchildcategory'




  #设备导入临时使用  -----
  get '/devices/importd' => 'devices#importd'
  post '/devices/importcreate' => 'devices#importcreate'
  post '/devices/importassign' => 'devices#importassign'
  post '/devices/batchassign' => 'devices#batchassign'
  #--------------------------
  #下面设备的路由
  get '/ajaxgetdevice' => 'devices#ajaxgetdevice'
  get '/ajaxgetalldevice' => 'devices#ajaxgetalldevice'
  get '/devices/batchadd' => 'devices#batchadd'
  post '/devices/batchcreate' => 'devices#batchcreate'
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
  



  #获取部门下的所有用户
  get '/ajaxgetuser' => 'departments#departmentusers'
  #部门相关
  get '/ajaxgetlowerdepartments' => 'departments#lowerdepartments'
  resources :departments
  post '/departments/addlowerdepartment' => 'departments#addlowerdepartment'



  #用户的相关路由
  post "users/upload" => 'users#upload'
  get 'users/search' => 'users#search'
  resources :users do
  	post 'upload_avatar', on: :member
  	post 'updatepw', on: :member
    post 'assigndevise', on: :member
    post 'assignconsumable', on: :member
    post 'showupdate', on: :member   #在show页面的修改
  end



  #设备服务路由
  get 'deviceservices/devicenew/:device_id', to: 'deviceservices#devicenew'
  resources :deviceservices do
    post 'upload_img', on: :member
  end



  #其他服务路由
  resources :otherservices do
    post 'upload_img', on: :member
    get 'set_remind', on: :member
  end



  #耗材路由
  resources :consumables do
    get 'addstocknew', on: :member
    post 'addstock', on: :member
    get 'records', on: :collection
  end

  #日志
  get 'logs/search' => 'logs#search'
  resources :logs



  #配件路由
  get '/parts/batchadd' => 'parts#batchadd'
  post '/parts/batchcreate' => 'parts#batchcreate'
  get '/parts/search' => 'parts#search'
  get '/ajaxgetpart' => 'parts#ajaxgetpart'
  resources :parts do
    post 'attachdevice', on: :member
    post 'showupdate', on: :member
    get 'remove', on: :member
  end


  #配件分类路由
  resources :partcategorys do
    post 'editpartcategorycode', on: :collection
    post 'addchildcategory', on: :member
  end


  #系统设置
  resource :site

end
