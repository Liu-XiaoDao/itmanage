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
  end

  def edit
  end

  def update
  end

  def destory
  end

  private
    def deviceservice_params
      params.require(:deviceservice).permit(:device_id, :servicename, :serviceprovider, :price, :begin_date, :months, :describe)
    end

end
