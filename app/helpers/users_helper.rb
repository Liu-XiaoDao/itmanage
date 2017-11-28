module UsersHelper
	def device_type(decategory_id)   #返回设备的类型名
	    decategory = Decategory.find decategory_id
	    decategory.name
	end

	def department_name(department_id)   #返回部门名
	    department = Department.find department_id
	    department.department_name
	end

	def user_name(user_id)   #根据用户id返回用户名
		if user_id
			user = User.find user_id
	    	
	    	link_to user.username, edit_user_path(user)
		else
			'无'
		end
	end

	def device_status(status)   #返回设备状态
	    case status
	    when 1
	    	"未分配"
		when 2
		   	"办公使用"
		when 3
		   "闲置"
		when 4
		   "维修"
		when 5
		   "借用"
		when 6
		   "报废"
		when 7
		   "报废借用"
		when 8
		   "报废清理"
		else
		   "状态不详"
		end
	end

	def device_timeleft(borrow_timeleft)   #返回设备的类型名
	    if borrow_timeleft.to_i > 0
	    	borrow_timeleft.to_s + "天"
	    else
	    	"办公使用"
	    end
	end
end