module DevicesHelper
	def device_name(device_id)   #返回设备的类型名
	    device = Device.find device_id
	    device.asset_name
	end

end