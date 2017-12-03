class HomeController < ApplicationController
  	layout 'home'
  	def index
  		#设备数量
  		@devicesstatus = Device.select("status,count(status) as count").group(:status)
  		@recyclingDevices = Device.where(borrow_timeleft: 0)

  		@departments = Department.first(5)

  		@decategorys = Decategory.first(5)

  		@partcategorys = Partcategory.first(5)

      @consumables = Consumable.first(5)
  		# ExceptionMailer.exception_nitofy.deliver_now!

	end
end
