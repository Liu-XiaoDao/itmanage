class OtherservicesController < ApplicationController

  layout 'home'
  #其他服务列表
  def index
    @otherservices = Otherservice.all.order(id: :desc).paginate page: params[:page], per_page: 15
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
    @images = @otherservice.attached_files

    @oslengthens = Oslengthen.where(otherservice_id: @otherservice.id).order(id: :desc)
    #延长服务的new对象
    @oslengthen = Oslengthen.new
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

  #延长服务时间,服务到期续约
  def lengthen
    @otherservice = Otherservice.find params[:id]

    @oslengthen = Oslengthen.new
    @oslengthen.otherservice_id = @otherservice.id
    @oslengthen.serviceenddate = @otherservice.end_date
    @oslengthen.bagindate = params[:oslengthen][:bagindate]
    @oslengthen.enddate = params[:oslengthen][:enddate]
    @oslengthen.note = params[:oslengthen][:note]
    @oslengthen.price = params[:oslengthen][:price]

    @otherservice.end_date = @oslengthen.enddate

    if @otherservice.save && @oslengthen.save
      flash[:success] = "服务延长时间成功"
      redirect_to otherservice_path(@otherservice)
    else
      flash[:danger] = "服务延长时间失败"
      redirect_to otherservice_path(@otherservice)
    end
  end

  def lengthendestory
    # return render json: params
    @oslengthen = Oslengthen.find params[:leid]

    @otherservice = Otherservice.find params[:id]

    @otherservice.end_date = @oslengthen.serviceenddate

    if @otherservice.save && @oslengthen.destroy
      redirect_to request.referer
    end
  end

  def destory
  end

  #上传图片
  def upload_img
    @otherservice = Otherservice.find params[:id]

    #生成一个保存服务图片的路径的对象
    attached_file = AttachedFile.new
    attached_file.upload_file(file_param,@otherservice)

    if attached_file.save
      flash[:success] = "附件上传成功"
      redirect_to otherservice_path(@otherservice)
    else
      flash[:danger] = "附件上传失败"
      redirect_to otherservice_path(@otherservice)
    end
  end

  #设置是否提醒,为1时会提醒,关闭后也就是置为0,就不会再提醒了
  def set_remind
    @otherservice = Otherservice.find params[:id]
    @otherservice.closeremind = 1
    if @otherservice.save
      #设置成功
      flash[:success] = "服务关闭成功"
      redirect_to otherservice_path(@otherservice)
    else
      #设置失败
      flash[:success] = "服务关闭失败"
      redirect_to otherservice_path(@otherservice)
    end
  end

  private
    def otherservice_params
      params.require(:otherservice).permit(:servicename, :serviceprovider, :price, :begin_date, :months, :describe)
    end

    def file_param
      params[:otherservice][:describe]
    end
end
