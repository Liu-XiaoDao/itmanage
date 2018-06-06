class AuthorizationservicesController < ApplicationController

  layout 'home'

  #列出所有设备维保item
  def index
    @authorizationservices = Authorizationservice.all.paginate page: params[:page], per_page: 15
  end

  #新建维保服务页面
  def new
    @authorizationservice = Authorizationservice.new
    #因为是给设备添加维保服务,所以列出所有设备
    @authorizations = Authorization.all
  end

  #数据库中插入新的维保
  def create
    #新建一条记录  :device_id, :servicename, :serviceprovider, :price, :begin_date, :months, :describe
    @authorizationservice = Authorizationservice.new(authorizationservice_params)
    #用这个服务的开始时间和周期,计算出这个维保的到期时间
    @authorizationservice.end_date = (Time.parse(@authorizationservice.begin_date.try(:strftime, "%Y-%m-%d")) + params[:authorizationservice][:months].to_i.month).strftime("%Y-%m-%d")
    #拿到添加服务的设备
    @authorization = Authorization.find params[:authorizationservice][:authorization_id]
    #先在服务里面保存设备原本的维保到期时间
    @authorizationservice.authorizationscraptime = @authorization.end_date
    #然后再把设备的维保到期时间设置为,这个服务的结束时间
    @authorization.end_date = @authorizationservice.end_date
    #添加维保后设备应该就是可用的了,应该不会存在添加维保后还是过期的情况
    #保存设备和维保服务
    if @authorizationservice.save && @authorization.save
      flash[:success] = "设备的维保服务添加成功"
      redirect_to authorizationservices_path
    else
      @authorizations = Authorization.all
      render :new
    end

  end

  #显示一条维保详情
  def show
    #拿到这条设备维保服务信息
    @authorizationservice = Authorizationservice.find params[:id]
    #拿到这条服务下面的所有照片
    @images = @authorizationservice.serviceimgs
  end

  #返回修改一条维保记录的页面
  def edit
    #检测如果一个设备有多条维保记录,只有最后一条能修改
    @authorizationservice = Authorizationservice.find params[:id]    #要修改的记录
    @authorizations = Authorization.all
    #拿到这个设备的所有的维保服务中的最后一条,检查要修改的这条是否就是最后一条,只允许修改最后一条
    @newauthorizationservice = Authorizationservice.where(authorization_id: @authorizationservice.authorization_id).order(id: :desc).last
    #如过要修改的这条不是最后一条就不让修改,不显示修改页面,直接再跳回列表页
    if @authorizationservice.id != @newauthorizationservice.id
        flash[:danger] = "这条维保记录中的设备,在这条记录之后添加了其他维保,不能修改"
        return redirect_to authorizationservices_path
    end
  end

  #修改一条维保,要区分,设备是否改变,如果改变设备,要恢复之前设备的状态
  def update
    @authorizationservice = Authorizationservice.find params[:id]
    #如果设备没有改变
    #更改属性   :servicename, :serviceprovider, :price, :begin_date, :months, :describe
    @authorizationservice.update edit_params   #这个地方使用update直接改动数据库
    #使用开始时间和维保时长计算服务结束时间
    @authorizationservice.end_date = (Time.parse(@authorizationservice.begin_date.try(:strftime, "%Y-%m-%d")) + params[:authorizationservice][:months].to_i.month).strftime("%Y-%m-%d")
    #因为时间获取会改变,所以在这里在设置一下
    @authorization = Authorization.find params[:authorizationservice][:authorization_id]
    #结束时间
    @authorization.end_date = @authorizationservice.end_date

    #保存两条也得换成事物
    if @authorizationservice.save && @authorization.save
      flash[:success] = "设备的维保服务修改成功"
      redirect_to authorizationservices_path
    else
      @authorizations = Authorization.all
      render :edit
    end

  end


  #不使用删除功能,只能修改
  def destory
  end

  #这是从设备列表和详情还有邮件中链接跳转过来的,返回选择好设备的新建维保页面
  def authorizationnew
    @authorization_id = params[:authorization_id]
    @authorizationservice = Authorizationservice.new
    @authorizations = Authorization.all
  end


  #上传维保相关的一些图片
  def upload_img
    @authorizationservice = Authorizationservice.find params[:id]
    imgurl = save_img(params[:authorizationservice][:describe])
    #生成一个保存服务图片的路径的对象
    serviceimg = Serviceimg.new
    serviceimg.imgurl = imgurl
    serviceimg.original = params[:authorizationservice][:describe].original_filename
    serviceimg.authorizationservice = @authorizationservice
    #保存
    if serviceimg.save
      flash[:success] = "图片上传成功"
      redirect_to authorizationservice_path(@authorizationservice)
    else
      flash[:danger] = "图片上传失败"
      redirect_to authorizationservice_path(@authorizationservice)
    end
  end

  #保存图片
  def save_img(file)
    root_path = "#{Rails.root}/public"
    dir_path = "/images/service/#{Time.now.strftime('%Y%m')}"
    final_path = root_path + dir_path
    if !File.exist?(final_path)
      FileUtils.makedirs(final_path)
    end
    file_rename = "#{Digest::MD5.hexdigest(Time.now.to_s)}#{File.extname(file.original_filename)}"
    file_path = "#{final_path}/#{file_rename}"
    File.open(file_path,'wb+') do |item| #用二进制对文件进行写入
      item.write(file.read)
    end
    "#{dir_path}/#{file_rename}"
  end


  private
    def authorizationservice_params
      params.require(:authorizationservice).permit(:authorization_id, :servicename, :serviceprovider, :price, :begin_date, :months, :describe)
    end

    def edit_params
      params.require(:authorizationservice).permit(:servicename, :serviceprovider, :price, :begin_date, :months, :describe)
    end


end
