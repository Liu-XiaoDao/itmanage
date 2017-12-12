class DeviceservicesController < ApplicationController

  layout 'home'
  
  #列出所有设备维保item
  def index
    @deviceservices = Deviceservice.all.paginate page: params[:page], per_page: 15
  end
  
  #新建维保服务页面
  def new
    @deviceservice = Deviceservice.new
    #因为是给设备添加维保服务,所以列出所有设备
    @devices = Device.all
  end

  #数据库中插入新的维保
  def create
    #新建一条记录  :device_id, :servicename, :serviceprovider, :price, :begin_date, :months, :describe
    @deviceservice = Deviceservice.new(deviceservice_params)
    #用这个服务的开始时间和周期,计算出这个维保的到期时间
    @deviceservice.end_date = (Time.parse(@deviceservice.begin_date.try(:strftime, "%Y-%m-%d")) + params[:deviceservice][:months].to_i.month).strftime("%Y-%m-%d")
    #拿到添加服务的设备
    @device = Device.find params[:deviceservice][:device_id]
    #先在服务里面保存设备原本的维保到期时间
    @deviceservice.devicescraptime = @device.scrap_date
    #然后再把设备的维保到期时间设置为,这个服务的结束时间
    @device.scrap_date = @deviceservice.end_date
    #添加维保后设备应该就是可用的了,应该不会存在添加维保后还是过期的情况
    @device.is_scrap = 0
    #保存设备和维保服务
    if @deviceservice.save && @device.save
      flash[:success] = "设备的维保服务添加成功"
      redirect_to deviceservices_path
    else
      @devices = Device.all
      render :new
    end

  end

  #显示一条维保详情
  def show
    #拿到这条设备维保服务信息
    @deviceservice = Deviceservice.find params[:id]
    #拿到这条服务下面的所有照片
    @images = @deviceservice.serviceimgs
  end

  #返回修改一条维保记录的页面
  def edit
    #检测如果一个设备有多条维保记录,只有最后一条能修改
    @deviceservice = Deviceservice.find params[:id]    #要修改的记录
    @devices = Device.all
    #拿到这个设备的所有的维保服务中的最后一条,检查要修改的这条是否就是最后一条,只允许修改最后一条
    @newdeviceservice = Deviceservice.where(device_id: @deviceservice.device_id).order(id: :desc).last
    #如过要修改的这条不是最后一条就不让修改,不显示修改页面,直接再跳回列表页
    if @deviceservice.id != @newdeviceservice.id
        flash[:danger] = "这条维保记录中的设备,在这条记录之后添加了其他维保,不能修改"
        return redirect_to deviceservices_path
    end
  end

  #修改一条维保,要区分,设备是否改变,如果改变设备,要恢复之前设备的状态
  def update
    @deviceservice = Deviceservice.find params[:id]
    #检查修改前后设备是否改变
    if @deviceservice.device_id.to_i == params[:deviceservice][:device_id].to_i
      #如果设备没有改变
      #更改属性   :servicename, :serviceprovider, :price, :begin_date, :months, :describe
      @deviceservice.update edit_params   #这个地方使用update直接改动数据库
      #使用开始时间和维保时长计算服务结束时间
      @deviceservice.end_date = (Time.parse(@deviceservice.begin_date.try(:strftime, "%Y-%m-%d")) + params[:deviceservice][:months].to_i.month).strftime("%Y-%m-%d")
      #因为时间获取会改变,所以在这里在设置一下
      @device = Device.find params[:deviceservice][:device_id]
      #结束时间
      @device.scrap_date = @deviceservice.end_date
      #是否过期tag
      @device.is_scrap = 0
      #保存两条也得换成事物
      if @deviceservice.save && @device.save
        flash[:success] = "设备的维保服务修改成功"
        redirect_to deviceservices_path
      else
        @devices = Device.all
        render :edit
      end

    else
      #如果设备改变,先恢复对之前设备的修改
      @olddevice = Device.find @deviceservice.device_id
      @olddevice.scrap_date = @deviceservice.devicescraptime
      #旧设备根据原始设备维保到期时间修改,是否到期状态
      if (@olddevice.scrap_date - Time.now) < 0
      	@olddevice.is_scrap = 0
      else
      	@olddevice.is_scrap = 1
      end
      @olddevice.save  #旧设备保存

      #添加服务的设备设置成新的
      @deviceservice.device_id = params[:deviceservice][:device_id]

      #更改属性
      @deviceservice.update edit_params
      #使用开始时间和维保时长计算服务结束时间
      @deviceservice.end_date = (Time.parse(@deviceservice.begin_date.try(:strftime, "%Y-%m-%d")) + params[:deviceservice][:months].to_i.month).strftime("%Y-%m-%d")
      #拿到新设备,设置设备的维保到期时间个是否到期tag
      @device = Device.find params[:deviceservice][:device_id]
      @deviceservice.devicescraptime = @device.scrap_date
      @device.scrap_date = @deviceservice.end_date
      @device.is_scrap = 0
      #保存,事物事物
      if @deviceservice.save && @device.save
        flash[:success] = "设备的维保服务修改成功"
        redirect_to deviceservices_path
      else
        @devices = Device.all
        render :edit
      end
    end
  end


  #不使用删除功能,只能修改
  def destory
  end

  #这是从设备列表和详情还有邮件中链接跳转过来的,返回选择好设备的新建维保页面
  def devicenew
    @device_id = params[:device_id]
    @deviceservice = Deviceservice.new
    @devices = Device.all
  end


  #上传维保相关的一些图片
  def upload_img
    @deviceservice = Deviceservice.find params[:id]
    imgurl = save_img(params[:deviceservice][:describe])
    #生成一个保存服务图片的路径的对象
    serviceimg = Serviceimg.new
    serviceimg.imgurl = imgurl
    serviceimg.deviceservice = @deviceservice
    #保存
    if serviceimg.save
      flash[:success] = "图片上传成功"
      redirect_to deviceservice_path(@deviceservice)
    else
      flash[:danger] = "图片上传失败"
      redirect_to deviceservice_path(@deviceservice)
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
    def deviceservice_params
      params.require(:deviceservice).permit(:device_id, :servicename, :serviceprovider, :price, :begin_date, :months, :describe)
    end

    def edit_params
      params.require(:deviceservice).permit(:servicename, :serviceprovider, :price, :begin_date, :months, :describe)
    end


end
