module UsersHelper
  def device_type(decategory_id)   #返回设备的类型名
      decategory = Decategory.find decategory_id
      decategory.name
  end

  def department_name(department_id)   #返回部门名
      department = Department.find department_id
      department.department_name
  end
  #包含上级部门的部门名
  def parentdepartment_name(department_id)   #返回部门名
      department = Department.find department_id
      departmentname = department.department_name
      while !department.higher.blank?
        department = department.higher
        departmentname = department.department_name + ' --> ' + departmentname
      end
      departmentname
  end

  #包含上级分类的设备分类名--Decategory
  def parentdecategory_name(decategory_id)   #返回设备分类名
      decategory = Decategory.find decategory_id
      decategoryname = decategory.name
      while !decategory.mdecategory.blank?
        decategory = decategory.mdecategory
        decategoryname = decategory.name + ' --> ' + decategoryname
      end
      decategoryname
  end

  #包含上级分类的配件分类名
  def parentpartcategory_name(partcategory_id)   #返回配件分类名
      partcategory = Partcategory.find partcategory_id
      partcategoryname = partcategory.name
      while !partcategory.mpartcategory.blank?
        partcategory = partcategory.mpartcategory
        dpartcategoryname = partcategory.name + ' --> ' + partcategoryname
      end
      partcategoryname
  end


  def user_name(user_id)   #根据用户id返回用户名
    if user_id
      user = User.find user_id

        link_to user.username, user_path(user)
    else
      '无'
    end
  end

  def device_status(status)   #返回设备状态
    case status
    when 1
        "闲置"
    when 2
        "办公使用"
    when 3
       "人员借用"
    when 4
       "设备借用"
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
