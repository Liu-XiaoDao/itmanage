class DevicesController < ApplicationController

	layout 'home'


	def index
		@devices = Device.all
	end

	def new
		@device = Device.new
		@devices = Device.all
		@decategorys = Decategory.all
		@users = User.all
		@departments = Department.all
	end

	def create
		@user = User.find 1
		# @user.devices.create(device_params)
		@device = Device.new(device_params)
		# @device.user_id = @user.id
		# @device.decategory_id = 1
		if @device.save
			redirect_to devices_path
		else
			return render plain: @device.errors.full_messages[0]
			render :new
		end
		
	end

	def edit
		@device = Device.find params[:id]
		@decategorys = Decategory.all
	end


	def update
	    @device = Device.find(params[:id])
	 
	    if @device.update(device_params)
	      	redirect_to devices_path
	    else
	      	render 'edit'
	    end
  	end



  	def ajaxgetdevice
  		@devices = Device.where(decategory_id: params[:decategoryid])
	    render json: @devices
  	end


  private 
    def device_params
      params.require(:device).permit(:asset_code, :asset_name, :service_sn, :decategory_id, :managed_by, :asset_details, :belong_to, :status)
    end
end
