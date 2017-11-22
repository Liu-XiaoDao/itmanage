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
  end

  def update
  end

  def destory
  end

  private
    def otherservice_params
      params.require(:otherservice).permit(:servicename, :serviceprovider, :price, :begin_date, :months, :describe)
    end
end
