class DevicesController < ApplicationController

	layout 'home'


	def index
		@devices = Device.all
	end

	def new
		@device = Device.new
	end

	def create
		@device = Device.new(device_params)
		if @device.save
			redirect_to devices_path
		else
			render :new
		end
		
	end

	def edit
		@device = Device.find params[:id]
	end


	def update
	    @device = Device.find(params[:id])
	 
	    if @device.update(device_params)
	      	redirect_to devices_path
	    else
	      	render 'edit'
	    end
  	end


  private 
    def device_params
      params.require(:device).permit(:asset_code, :asset_name, :service_sn, :model, :managed_by, :asset_details, :belong_to, :status)
    end
end
