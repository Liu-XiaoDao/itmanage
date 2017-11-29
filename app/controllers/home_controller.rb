class HomeController < ApplicationController
  	layout 'home'
  	def index
  		#设备数量
  		@devicesstatus = Device.select("status,count(status) as count").group(:status)
  		@recyclingDevices = Device.where(borrow_timeleft: 0)

  		@departments = Department.all

  		@decategorys = Decategory.all

  		@partcategorys = Partcategory.all
	end
end
