class AssetzController < ApplicationController
	layout 'home'
	
	def index
		@assets = Asset.all
	end

	def new
		@asset = Asset.new
	end

	def create
		@asset = Asset.new(asset_params)

		# if @asset.save
			render plain: "OK"
		# else
		# 	render :new
		# end
		
	end


  private 
    def asset_params
      params.require(:asset).permit(:asset_code, :asset_name, :service_sn, :model, :managed_by, :asset_details, :belong_to, :status)
    end
end
