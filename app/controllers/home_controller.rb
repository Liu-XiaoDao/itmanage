class HomeController < ApplicationController
	layout 'home'
	def index
		#设备数量
		# @devicesstatus = Device.select("status,count(status) as count").group(:status)
		# @recyclingDevices = Device.where(borrow_timeleft: 0)
		@departments = Department.first(5)
		@decategorys = Decategory.first(5)
		@partcategorys = Partcategory.first(5)
		@consumables = Consumable.first(5)
		@devices = Device.first(5)
		@users = User.first(5)

		@devices = Device.first(5)
		@parts = Part.first(5)
		@deviceservices = Deviceservice.first(5)
		@otherservices = Otherservice.first(5)




		#设备使用率
		@devicescount = Device.all.blank? ? 1 : Device.all.count
		@useddevicescount = Device.where(is_assign: 0).blank? ? 0 : Device.where(is_assign: 0).count
		@devicepercent = @useddevicescount / @devicescount * 100
		#配件使用率
		@partscount = Part.all.blank? ? 1 : Part.all.count
		@usedpartscount = Part.where(is_assign: 0).blank? ? 0 : Part.where(is_assign: 0).count
		@partpercent = @useddevicescount / @devicescount * 100
		#耗材剩余率
		@consumables = Consumable.all
		@consumablescount = 0
		@usedconsumablescount = 0
		@consumables.each do |consumable|
			@consumablescount = @consumablescount + consumable.amount
			@usedconsumablescount = @usedconsumablescount + consumable.surplus_amount
		end
		@consumablepercent = @usedconsumablescount / @consumablescount * 100
		#员工
		nowtime = Time.zone.now
        searchstr = "created_at between '#{nowtime.try(:strftime, '%Y-%m-%d')}' And '#{nowtime.try(:strftime, '%Y-%m-%d')}'"
		@userscount = User.where(searchstr).blank? ? 0 : User.where(searchstr).count
		@allusercount = User.all.blank? ? 1 : User.all.count
		@userpercent = @userscount / @allusercount * 100
	end
end
