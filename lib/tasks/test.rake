namespace :device do	
	desc "每天遍历设备.当超过维保时间,设置is_scrap为1,并发邮件"
	task(:scrap => :environment) do
	  devices = Device.all

	  senddevice = []

	  for device in devices
	  	if (Time.parse(device.scrap_date.try(:strftime, "%Y-%m-%d")) - Time.now) < 0
	  		device.is_scrap = 1
	  		device.save
	  	end

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
