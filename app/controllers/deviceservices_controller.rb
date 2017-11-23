class DeviceservicesController < ApplicationController

  layout 'home'
  
  def index
    @deviceservices = Deviceservice.all.paginate page: params[:page], per_page: 10
  end

  def new
    @deviceservice = Deviceservice.new
    @devices = Device.all
  end

  def create
    @deviceservice = Deviceservice.new(deviceservice_params)
    @deviceservice.end_date = (Time.parse(@deviceservice.begin_date.try(:strftime, "%Y-%m-%d")) + params[:deviceservice][:months].to_i.month).strftime("%Y-%m-%d")

    @device = Device.find params[:deviceservice][:device_id]
    @device.scrap_date = @deviceservice.end_date
    
    if @deviceservice.save && @device.save
      redirect_to deviceservices_path
    else
      render :new
    end


    # render plain: Time.now
  end

  def show
    @deviceservice = Deviceservice.find params[:id]
    @images = @deviceservice.serviceimgs
  end

  def edit
  end

  def update
  end

  def destory
  end


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
