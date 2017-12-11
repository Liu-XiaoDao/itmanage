class OtherservicesController < ApplicationController
  
  layout 'home'
  #其他服务列表
  def index
    @otherservices = Otherservice.all.paginate page: params[:page], per_page: 15
  end
  #其他服务新建页面
  def new
    @otherservice = Otherservice.new
  end
  #新建其他服务
  def create
  	#其他服务对像   :servicename, :serviceprovider, :price, :begin_date, :months, :describe
    @otherservice = Otherservice.new(otherservice_params)
    #其他服务结束时间
    @otherservice.end_date = (Time.parse(@otherservice.begin_date.try(:strftime, "%Y-%m-%d")) + params[:otherservice][:months].to_i.month).strftime("%Y-%m-%d")
    #其他服务的开始提醒时间
    @otherservice.remindtime = (Time.parse(@otherservice.end_date.try(:strftime, "%Y-%m-%d")) - 2.month).strftime("%Y-%m-%d")
    #保存
    if @otherservice.save
      flash[:success] = "其他服务新建成功"
      redirect_to otherservices_path
    else
      render :new
    end

  end
  #服务的详情
  def show
  	#拿到一条服务
    @otherservice = Otherservice.find params[:id]
    #这条服务下的所有图片
    @images = @otherservice.oserviceimgs
  end
  #修改其他服务
  def edit
    @otherservice = Otherservice.find params[:id]
  end

  #修改
  def update
  	#其他服务对像   :servicename, :serviceprovider, :price, :begin_date, :months, :describe
    @otherservice = Otherservice.find params[:id]
    @otherservice.servicename = params[:otherservice][:servicename]
    @otherservice.serviceprovider = params[:otherservice][:serviceprovider]
    @otherservice.price = params[:otherservice][:price]
    @otherservice.begin_date = params[:otherservice][:begin_date]
    @otherservice.months = params[:otherservice][:months]
    @otherservice.describe = params[:otherservice][:describe]
    #计算时间
    @otherservice.end_date = (Time.parse(@otherservice.begin_date.try(:strftime, "%Y-%m-%d")) + params[:otherservice][:months].to_i.month).strftime("%Y-%m-%d")
    @otherservice.remindtime = (Time.parse(@otherservice.end_date.try(:strftime, "%Y-%m-%d")) - 2.month).strftime("%Y-%m-%d")
    
    if @otherservice.save
      flash[:success] = "其他服务修改成功"
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
  #设置是否提醒,为1时会提醒,关闭后也就是置为0,就不会再提醒了
  def set_remind
    @otherservice = Otherservice.find params[:id]
    @otherservice.closeremind = params[:tag]
    if @otherservice.save
      #设置成功
      render json: {status: 0}
    else
      #设置失败
      render json: {status: 1}
    end
  end

  private
    def otherservice_params
      params.require(:otherservice).permit(:servicename, :serviceprovider, :price, :begin_date, :months, :describe)
    end
end
