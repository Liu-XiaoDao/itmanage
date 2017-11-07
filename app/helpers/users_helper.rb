module UsersHelper
	def device_type(decategory_id)   #返回设备的类型名
	    decategory = Decategory.find decategory_id
	    decategory.name
	end

	def device_status(status)   #返回设备状态
	    case status
	    when 0
	    	"未分配"
		when 1
		   	"办公使用"
		when 2
		   "闲置"
		when 3
		   "维修"
		when 4
		   "借用"
		when 5
		   "报废"
		when 6
		   "报废借用"
		when 7
		   "报废清理"
		else
		   "状态不详"
		end
	end

	def device_timeleft(borrow_timeleft)   #返回设备的类型名
	    if borrow_timeleft > 0
	    	borrow_timeleft.to_s + "天"
	    else
	    	"办公使用"
	    end
	end
end