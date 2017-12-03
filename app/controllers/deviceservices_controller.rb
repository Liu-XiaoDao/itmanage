class DeviceservicesController < ApplicationController

  layout 'home'
  
  #列出所有维保item
  def index
    @deviceservices = Deviceservice.all.paginate page: params[:page], per_page: 10
  end
  
  #新建维保服务页面
  def new
    @deviceservice = Deviceservice.new
    @devices = Device.all
  end

  #数据库中插入新的维保
  def create
    @deviceservice = Deviceservice.new(deviceservice_params)
    @deviceservice.end_date = (Time.parse(@deviceservice.begin_date.try(:strftime, "%Y-%m-%d")) + params[:deviceservice][:months].to_i.month).strftime("%Y-%m-%d")

    @device = Device.find params[:deviceservice][:device_id]
    @device.scrap_date = @deviceservice.end_date
    @device.is_scrap = 0
    
    if @deviceservice.save && @device.save
      redirect_to deviceservices_path
    else
      render :new
    end

  end

  #显示一条维保详情
  def show
    @deviceservice = Deviceservice.find params[:id]
    @images = @deviceservice.serviceimgs
  end

  #返回修改一条维保记录的页面
  def edit
    @deviceservice = Deviceservice.find params[:id]
    @devices = Device.all
  end

  #修改一条维保
  def update
    @deviceservice = Deviceservice.find params[:id]

    if @deviceservice.device_id.to_i == params[:deviceservice][:device_id].to_i
      @deviceservice.servicename = params[:deviceservice][:servicename]
      @deviceservice.serviceprovider = params[:deviceservice][:serviceprovider]
      @deviceservice.price = params[:deviceservice][:price]
      @deviceservice.begin_date = params[:deviceservice][:begin_date]
      @deviceservice.months = params[:deviceservice][:months]
      @deviceservice.describe = params[:deviceservice][:describe]

      @deviceservice.end_date = (Time.parse(@deviceservice.begin_date.try(:strftime, "%Y-%m-%d")) + params[:deviceservice][:months].to_i.month).strftime("%Y-%m-%d")

      @device = Device.find params[:deviceservice][:device_id]
      @device.scrap_date = @deviceservice.end_date
      @device.is_scrap = 0
      
      if @deviceservice.save && @device.save
        redirect_to deviceservices_path
      else
        render :edit
      end

    else
      #如果设备改变,先恢复对之前设备的修改
      @olddevice = Device.find @deviceservice.device_id
      @olddevice.scrap_date = (Time.parse(@olddevice.scrap_date.try(:strftime, "%Y-%m-%d")) - @deviceservice.months.month).strftime("%Y-%m-%d")
      #旧设备根据原始设备维保到期时间修改,是否到期状态
      if (@olddevice.scrap_date - Time.now) < 0
      	@olddevice.is_scrap = 0
      else
      	@olddevice.is_scrap = 1
      end

      @olddevice.save


      @deviceservice.device_id = params[:deviceservice][:device_id]
      @deviceservice.servicename = params[:deviceservice][:servicename]
      @deviceservice.serviceprovider = params[:deviceservice][:serviceprovider]
      @deviceservice.price = params[:deviceservice][:price]
      @deviceservice.begin_date = params[:deviceservice][:begin_date]
      @deviceservice.months = params[:deviceservice][:months]
      @deviceservice.describe = params[:deviceservice][:describe]

      @deviceservice.end_date = (Time.parse(@deviceservice.begin_date.try(:strftime, "%Y-%m-%d")) + params[:deviceservice][:months].to_i.month).strftime("%Y-%m-%d")

      @device = Device.find params[:deviceservice][:device_id]
      @device.scrap_date = @deviceservice.end_date
      @device.is_scrap = 0
      if @deviceservice.save && @device.save
        redirect_to deviceservices_path
      else
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

    serviceimg = Serviceimg.new
    serviceimg.imgurl = imgurl
    serviceimg.deviceservice = @deviceservice

    if serviceimg.save
      redirect_to deviceservice_path(@deviceservice)
    else
      
    end
  end

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

end
