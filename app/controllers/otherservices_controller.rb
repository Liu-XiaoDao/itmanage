class OtherservicesController < ApplicationController
  
  layout 'home'
  
  def index
    @otherservices = Otherservice.all.paginate page: params[:page], per_page: 10
  end

  def new
    @otherservice = Otherservice.new
  end

  def create

    @otherservice = Otherservice.new(otherservice_params)
    @otherservice.end_date = (Time.parse(@otherservice.begin_date.try(:strftime, "%Y-%m-%d")) + params[:otherservice][:months].to_i.month).strftime("%Y-%m-%d")
    @otherservice.remindtime = (Time.parse(@otherservice.end_date.try(:strftime, "%Y-%m-%d")) - 2.month).strftime("%Y-%m-%d")
        # return render json: @otherservice
    if @otherservice.save
      redirect_to otherservices_path
    else
      render :new
    end

  end

  def show
    @otherservice = Otherservice.find params[:id]
    @images = @otherservice.oserviceimgs
    # render json: @otherservice
  end

  def edit
    @otherservice = Otherservice.find params[:id]
  end

  #修改
  def update
    @otherservice = Otherservice.find params[:id]

    @otherservice.servicename = params[:otherservice][:servicename]
    @otherservice.serviceprovider = params[:otherservice][:serviceprovider]
    @otherservice.price = params[:otherservice][:price]
    @otherservice.begin_date = params[:otherservice][:begin_date]
    @otherservice.months = params[:otherservice][:months]
    @otherservice.describe = params[:otherservice][:describe]

    @otherservice.end_date = (Time.parse(@otherservice.begin_date.try(:strftime, "%Y-%m-%d")) + params[:otherservice][:months].to_i.month).strftime("%Y-%m-%d")
    @otherservice.remindtime = (Time.parse(@otherservice.end_date.try(:strftime, "%Y-%m-%d")) - 2.month).strftime("%Y-%m-%d")
    
    if @otherservice.save
      redirect_to otherservices_path
    else
      render :edit
    end
  end

  def destory
  end

  #上传图片
  def upload_img
    @otherservice = Otherservice.find params[:id]
    imgurl = save_img(params[:otherservice][:describe])

    oserviceimg = Oserviceimg.new
    oserviceimg.imgurl = imgurl
    oserviceimg.otherservice = @otherservice

    if oserviceimg.save
      redirect_to otherservice_path(@otherservice)
    else
      
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

  def set_remind
    @otherservice = Otherservice.find params[:id]
    @otherservice.closeremind = params[:tag]
    if @otherservice.save
      redirect_to otherservice_path(@otherservice)
    else
      
    end
  end

  private
    def otherservice_params
      params.require(:otherservice).permit(:servicename, :serviceprovider, :price, :begin_date, :months, :describe)
    end
end
