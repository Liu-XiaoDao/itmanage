class HomeController < ApplicationController
  	layout 'home'
  	def index
  		@devicesstatus = Device.select("status,count(status) as count").group(:status)
  		@recyclingDevices = Device.where(borrow_timeleft: 0)
#  		return render json: @recyclingDevices
	end
end
