module PartsHelper
  	def part_type(partcategory_id)   #返回配件的类型名
	    partcategory = Partcategory.find partcategory_id
	    partcategory.name
	end

	def device_name(device_id)   #返回属于的设备
	    
	    if device_id
			device = Device.find device_id
	    	device.asset_code
	    	link_to device.asset_code, device_path(device)
		else
			'无'
		end
	end

	def is_assin(is_assin)
		case is_assin
	    when 0
	    	"是"
		when 1
		   	"否"
		else
		   "状态不详"
		end
	end

	def part_status(status)   #返回设备状态
	    case status
	    when 1
	    	"未使用"
		when 2
		   	"正在使用"
		when 3
		   "闲置"
		when 4
		   "损坏"
		else
		   "状态不详"
		end
	end
end
