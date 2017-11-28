module DevicesHelper
	def device_name(device_id)   #返回设备名
	    device = Device.find device_id
	    device.asset_name
	end

	def device_assetno(device_id)   #返回设备名
	    device = Device.find device_id
	    device.asset_code

	    if device_id
			device = Device.find device_id
	    	link_to device.asset_code, device_path(device)
		else
			'无'
		end
	end

end