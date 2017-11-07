class DevicesController < ApplicationController

	layout 'home'


	def index
		@devices = Device.all
		@departments = Department.all
	end

	def new
		@device = Device.new
		@devices = Device.all
		@decategorys = Decategory.all
	end

	def create
		# return render json: device_params
		@user = User.find 1
		@device = Device.new(device_params)

		if @device.save
			redirect_to devices_path
		else

		end
		
	end

	def edit
		@device = Device.find params[:id]
		@devices = Device.all
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

  	def destroy
	    @device = Device.find(params[:id])
		@device.destroy
	    
	    redirect_to devices_path
  	end


  	def ajaxgetdevice
  		@devices = Device.where(decategory_id: params[:decategoryid], is_assign: 0)
	    render json: @devices
  	end


  private 
    def device_params
      params.require(:device).permit(:asset_code, :asset_name, :service_sn, :decategory_id, :receive_date, :asset_details, :belong_to, :status)
    end
end
