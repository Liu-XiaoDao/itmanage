namespace :device do
	desc "每天遍历一遍设备,根据维保日期,设置设备的is_scrap属性"
	task(:scrap => :environment) do
	  devices = Device.all

	  for device in devices
	  	if (Time.parse(device.scrap_date.try(:strftime, "%Y-%m-%d")) - Time.now) < 0
	  		device.is_scrap = 1
	  		device.save
	  	end
	  end

	end

	desc "查询其他服务,在设置的提示时间开始后,每周一提醒一次"
	task(:oservice => :environment) do
		otherservices = Otherservice.where("remindtime <= :now_date AND closeremind = 0",{now_date: Time.now})
		# otherservices.each{ |otherservice| puts otherservice.servicename }
		ExceptionMailer.service_nitofy(otherservices).deliver_now!
	end

	desc "每天遍历设备.当超过维保时间,设置is_scrap为1"
	task(:devicemail => :environment) do
	  devices = Device.where(is_delete: 0)

	  senddevice = []

	  for device in devices
	  	if (Time.parse(device.scrap_date.try(:strftime, "%Y-%m-%d")) - Time.now) < 2592000
	  		senddevice.push device
	  	end
	  end

	  senddevice.each{|device| puts device.asset_name }

	  ExceptionMailer.scrap_nitofy(senddevice).deliver_now!
	end
end
# namespace :utils do
#   desc "Finds soon to expire subscriptions and emails users"
#   task(:send_expire_soon_emails => :environment) do
#     # Find users to email
#     for user in User.all
#       puts "Emailing #{user.username}"
#       ExceptionMailer.exception_nitofy.deliver_now!
#     end
#   end
# end
