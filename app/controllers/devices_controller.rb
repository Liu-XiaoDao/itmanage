class DevicesController < ApplicationController

	layout 'home'

	def index
		#设备列表显示is_delete为0的设备
		@devices = Device.where(is_delete: 0).paginate page: params[:page], per_page: 10
		@departments = Department.all
		@decategorys = Decategory.all
		@users = User.all
		@status = YAML.load_file("#{Rails.root}/config/status.yml")['device']

		# @decategorys = GetTree(@decategorys,0,0,@tree = [],'--')
		# @decategorys = @tree
	end




  	#搜索设备
	def search
		@decategory_id = params[:device][:decategory_id]
	    @user_id = params[:device][:user_id]
	    @status_id = params[:device][:status_id]
	    @scrap_date = params[:device][:scrap_date]

		if @decategory_id.blank? && @user_id.blank? && @status_id.blank? && @scrap_date.blank?
		  redirect_to devices_path
		else
		  searchstr = ''
		  if !@decategory_id.blank?
		    searchstr += "decategory_id = #{@decategory_id}"
		  end

		  if !@user_id.blank?
		    andstr = searchstr.blank? ? "" : " and "
		    searchstr = searchstr + andstr
		    searchstr += "user_id = #{@user_id}"
		  end

		  if !@status_id.blank?
		    andstr = searchstr.blank? ? "" : " and "
		    searchstr = searchstr + andstr
		    searchstr += "status = #{@status_id}"
		  end

		  if !@scrap_date.blank?
		    andstr = searchstr.blank? ? "" : " and "
		    
		    begindate = Time.parse(@scrap_date) - 1.months
		    enddate = Time.parse(@scrap_date) + 1.months

		    searchstr = searchstr + andstr
		    searchstr += "scrap_date between '#{begindate.try(:strftime, '%Y-%m-%d')}' And '#{enddate.try(:strftime, '%Y-%m-%d')}'"
		  end
# return render plain: searchstr
		  @devices = Device.where(searchstr).paginate page: params[:page], per_page: 10

		  @departments = Department.all
		  @decategorys = Decategory.all
		  @users = User.all
		  @status = YAML.load_file("#{Rails.root}/config/status.yml")['device']

	    render "index"

		end
	end



  	#添加设备试图
	def new
		@device = Device.new
		# @devices = Device.all
		@decategorys = Decategory.all
		# GetTree(Decategory.all,0,0,@decategorys,"|----")
	end

	#添加设备
	def create
		@device = Device.new(device_params)
		# @device.asset_code = getassetcode(params[:device][:decategory_id])
		@device.asset_code = params[:device][:asset_code]
		@device.scrap_date = Time.parse(@device.release_date.try(:strftime, "%Y-%m-%d")) + params[:device][:guaranteed].to_i.months
		if @device.save
			redirect_to devices_path
		else
			@decategorys = Decategory.all
			render :new
		end
	end

	#批量添加界面
	def batchadd
		@device = Device.new
		@decategorys = Decategory.all
	end

	#批量添加设备
	def batchcreate

		devicecount = params[:device][:count].to_i
		if devicecount <= 0
			devicecount = 0
		end
   
		i = 0
		while i < devicecount  do
		   device = Device.new
		   device.asset_name = params[:device][:name]
		   device.asset_code = getassetcode(params[:device][:decategory_id])
		   device.release_date = params[:device][:release_date]
		   device.decategory_id = params[:device][:decategory_id]
		   device.asset_details = params[:device][:asset_details]

		   device.scrap_date = Time.parse(device.release_date.try(:strftime, "%Y-%m-%d")) + params[:device][:guaranteed].to_i.months

		   device.save
		   i +=1
		end
		redirect_to devices_path
	end

	def edit
		@device = Device.find params[:id]
		@decategorys = Decategory.all
	end


	def update
		@device = Device.find(params[:id])
		if params[:device][:release_date].blank? && params[:device][:scrap_date].blank?
			@device.decategory_id = params[:device][:decategory_id]
			@device.asset_name = params[:device][:asset_name]
			@device.service_sn = params[:device][:service_sn]
			@device.asset_details = params[:device][:asset_details]
		else
			@device.decategory_id = params[:device][:decategory_id]
			@device.asset_name = params[:device][:asset_name]
			@device.service_sn = params[:device][:service_sn]
			@device.release_date = params[:device][:release_date]
			@device.scrap_date = params[:device][:scrap_date]
			@device.asset_details = params[:device][:asset_details]
		end

	    if @device.save
	      	redirect_to device_path(@device)
	    else
	      	render 'edit'
	    end
  	end

  	def showupdate
	    @device = Device.find(params[:id])
	    device_params = params.require(:device).permit(:asset_name, :service_sn, :decategory_id, :asset_details, :location)
	    if @device.update(device_params)
	    	flash[:warning] = "修改成功"
	      	redirect_to device_path(@device)
	    else
	    	flash[:warning] = "修改失败"
	      	render 'show'
	    end
  	end

  	#删除,但是因为其他表的外键依赖,所以添加is_delete属性,删除的话此属性设置为1
  	def destroy
	    @device = Device.find(params[:id])
		@device.is_delete = 1

		if @device.save
			redirect_to devices_path
		end
  	end

	#用户详情页中分配设备是ajax获得设备的方法
  	def ajaxgetdevice
	    if params[:status] == '7' #如果等于7就是报废借用,寻找报废的设备
	    	@devices = Device.where(decategory_id: params[:decategoryid], is_assign: 0, is_scrap: 1)
	    else
	    	@devices = Device.where(decategory_id: params[:decategoryid], is_assign: 0, is_scrap: 0)
	    end

	    render json: @devices
  	end

  	#在配件show中的附加到设备方法使用(ajax获得)
  	def ajaxgetalldevice
  		@devices = Device.where(decategory_id: params[:decategoryid])
	    render json: @devices
  	end


  	def show
  		@device = Device.find(params[:id])  #当前设备
  		@parts = @device.parts   #从属设备

  		@user = @device.user   #设备的使用人
  		@decategorys = Decategory.all     #设备分类,拿到所有分类
  		@partcategorys = Partcategory.all     #配件分类,拿到所有分类
  		@departments = Department.all

  		@devicerecords = @device.devicerecords
  	end

  	#ajax修改设备名
  	def editdeviceassetname
  		device = Device.find params[:id]  #当前设备
	    device.asset_name = params[:asset_name]
	    device.save 
  	end

  	#ajax修改设备服务号
  	def editdeviceservicesn
  		device = Device.find params[:id]  #当前设备
	    device.service_sn = params[:service_sn]
	    device.save
  	end

  	#ajax修改设备详情
  	def editdeviceassetdetails
  		device = Device.find params[:id]  #当前设备
	    device.asset_details = params[:asset_details]
	    device.save
  	end

  	#分配设备(user控制器中也有应该提取出来)
	def assigndevise

		#分配数据完整性验证
		user_id = params[:device][:user_id]  #用户id
		assign_type = params[:device][:assigntype]  #分配方式(设备状态)
		borrow_timeleft = params[:device][:borrowtime]
		if user_id.blank? || assign_type.blank? || ( assign_type.to_i == 5 && borrow_timeleft.blank?) || ( assign_type.to_i == 7 && borrow_timeleft.blank?)  
			return render js: "$('#error-infoassign').html('信息不全').css('display','block');"
		end

	    #使用设备id拿到设备
	    @device = Device.find params[:id]
		
	    #等于1,表示是新添加设备之前从未有人使用,第一次分配时要,设置第一次分配时间,原本还要设置报废时间,但是报废时间不根据第一次分配时间设置,所以这里取消掉这个逻辑{{4年的报废时间}}
	    if @device.status == 1
	      @device.first_date = Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")
	    end
		
	    #分配设备,设备的user_id设置为当前用户的id
	    @device.user_id = params[:device][:user_id]
	    #分配设备是设备的状态只有两种借用或者办公用,其他状态在设备页自己处理
	    @device.status = params[:device][:assigntype]
	    #根据分配类型,设置是否有借用天数
	    if params[:device][:assigntype].to_i == 5 || params[:device][:assigntype].to_i == 7
	      @device.borrow_timeleft = params[:device][:borrowtime]   #借用时间,再这设置为借用剩余时间,最后定时任务,每天自动减1,当时间为0,提醒管理员收回电脑
	    else
	      @device.borrow_timeleft = -1  #-1代表不会到期
	    end
		
	    @device.assign_time = Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")
	    @device.is_assign = 1
	    # return render json: params
	    
	    @devicerecord = Devicerecord.new
	    @devicerecord.user_id = user_id
	    @devicerecord.device_id = @device.id
	    @devicerecord.note = device_status @device.status

	    if @device.save && @devicerecord.save
	    	return render js: "location.reload();"#保存成功使用js刷新页面
	    else
	    	return render js: "$('#error-infoassign').html('没有分配成功').css('display','block');"
	    end
	    
	end


	#添加从属设备
	def appendpart

		append_part_id = params[:part][:part_id]   #选中配件的id
		if append_part_id.blank?
			flash[:warning] = "添加配件失败,没有选择配件"
	    	return redirect_to device_path(params[:id])
		end
		@device = Device.find params[:id] #当前设备

		@append_part = Part.find append_part_id #要添加的配件
		@append_part.device = @device   #设备属于另外哪一个设备
		@append_part.is_assign = 1
		@append_part.assign_time = Time.now
	    @append_part.status = 2 #表明配件已经被使用

	    #配件安装记录
	    @partrecord = Partrecord.new
	    @partrecord.part_id = append_part_id
	    @partrecord.device_id = @device.id
	    @partrecord.note = "安装配件"

		if @append_part.save && @partrecord.save 
	    	redirect_to device_path(params[:id])
	    else
	    	flash[:warning] = "添加配件失败"
	    	redirect_to device_path(params[:id])
	    end

	end


	#设备回收
	def recycle
		#使用设备id拿到设备
		@device = Device.find params[:id]
		#保存设备的使用者,回收设备后跳转回用户详情页
		user = @device.user_id
		#设备分配日志
		@devicerecord = Devicerecord.new
		@devicerecord.user_id = @device.user_id
		@devicerecord.device_id = @device.id
		@devicerecord.note = "回收设备"
		#回收设备是区分是否超过维保时间
		if @device.is_scrap == 1   #超过维保的
			#回收设备,设备的状态设置为报废 6
			@device.status = 6
			@device.borrow_timeleft = -3  #-3报废状态下的值
		else
			#回收设备,设备的状态设置为闲置
			@device.status = 3
			@device.borrow_timeleft = -2  #-2闲置状态下的值
		end
		#回收设备,设备的user_id设置nil
		@device.user_id = nil
		@device.assign_time = Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")
		@device.is_assign = 0

		if @device.save && @devicerecord.save
			flash[:warning] = "设备回收成功"
			redirect_to user_path(user)
		else
			flash[:warning] = "设备回收失败"
	    	redirect_to user_path(user)
		end
	end

	#设置设备状态
	def setstatus
		# return render json: params
		#使用设备id拿到设备
		@device = Device.find params[:id]
		status = params[:device][:status]
		if @device.is_assign == 1
			return render js: "$('#error-infostatus').html('当前设备正在被使用不允许设置状态').css('display','block');"
		end

		if @device.is_scrap == 0
			if status == '6' || status == '8'
				return render js: "$('#error-infostatus').html('当前设备没有超过维保时间,不能报废或清理').css('display','block');"
			end
		else
			if status == '3' || status == '4'
				return render js: "$('#error-infostatus').html('当前设置已经超过维保,请续保后再设置状态').css('display','block');"
			end
		end

		@device.status = status

		if @device.save
		   	return render js: "location.reload();"#保存成功使用js刷新页面
		else
			return render js: "$('#error-infostatus').html('信息不全').css('display','block');"
		end
	end




	#导入设备-------临时使用----------------------------------------------------
	def importd
		@users = User.all
		@devices = Device.all
	end
	
	#批量添加设备
	def importcreate
		@importdevices = params[:devices].split(";")
		@importdevices.each do |devicestr|
			device = devicestr.split(",")
			newdevice = Device.new
			newdevice.asset_name = device[1]
			newdevice.service_sn = device[3]
			newdevice.decategory_id = device[2]
			newdevice.release_date = '20' + device[0][2] + device[0][3] + '-' + device[0][4] + device[0][5] + '-01'
			newdevice.asset_details = "导入"
			newdevice.location = device[4]
			newdevice.asset_code = device[0]
			newdevice.scrap_date = Time.parse(newdevice.release_date.try(:strftime, "%Y-%m-%d")) + 48.months
			
			unless newdevice.save
				flash[:success] = "设备" + newdevice.asset_code + "导入失败" + newdevice.errors.full_messages[0]
				return redirect_to devices_path
			end
	    end
	    flash[:success] = "设备导入成功"
		redirect_to devices_path
	end

	def batchassign
		@deviceusers = params[:deviceusers].split(";")
		@deviceusers.each do |deviceuserstr|
			deviceuser = deviceuserstr.split(",")
			user_id = User.find_by(username: deviceuser[0]).id
			device_id = Device.find_by(asset_code: deviceuser[1]).id
			batchassignuser(user_id,device_id)
	    end
		return render js: "$('#error-infoassign').html('设备导入成功').css('display','block');"
	end

	#导入设备快速分配
	def batchassignuser(user_id,device_id)

		if user_id.blank? || device_id.blank?  
			return render js: "$('#error-infoassign').html('信息不全').css('display','block');"
		end
	    #使用设备id拿到设备
	    @device = Device.find device_id
	    #等于1,表示是新添加设备之前从未有人使用,第一次分配时要,设置第一次分配时间,原本还要设置报废时间,但是报废时间不根据第一次分配时间设置,所以这里取消掉这个逻辑{{4年的报废时间}}
	    if @device.status == 1
	      @device.first_date = Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")
	    end
	    #分配设备,设备的user_id设置为当前用户的id
	    @device.user_id = user_id
	    #分配设备是设备的状态只有两种借用或者办公用,其他状态在设备页自己处理
	    @device.status = 2

	    @device.borrow_timeleft = -1  #-1代表不会到期

		
	    @device.assign_time = Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")
	    @device.is_assign = 1
	    
	    @devicerecord = Devicerecord.new
	    @devicerecord.user_id = user_id
	    @devicerecord.device_id = @device.id
	    @devicerecord.note = device_status @device.status

	    if @device.save && @devicerecord.save
	    else
	    	return render js: "$('#error-infoassign').html('没有分配成功').css('display','block');"
	    end
	end




	#导入设备快速分配
	def importassign
		#分配数据完整性验证
		user_id = params[:user_id]  #用户id
		assign_type = params[:assigntype]  #分配方式(设备状态)
		borrow_timeleft = params[:borrowtime]
		device_id = params[:device_id]
		if user_id.blank? || assign_type.blank? || ( assign_type.to_i == 5 && borrow_timeleft.blank?) || ( assign_type.to_i == 7 && borrow_timeleft.blank?)  
			return render js: "$('#error-infoassign').html('信息不全').css('display','block');"
		end
	    #使用设备id拿到设备
	    @device = Device.find device_id
	    #等于1,表示是新添加设备之前从未有人使用,第一次分配时要,设置第一次分配时间,原本还要设置报废时间,但是报废时间不根据第一次分配时间设置,所以这里取消掉这个逻辑{{4年的报废时间}}
	    if @device.status == 1
	      @device.first_date = Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")
	    end
	    #分配设备,设备的user_id设置为当前用户的id
	    @device.user_id = user_id
	    #分配设备是设备的状态只有两种借用或者办公用,其他状态在设备页自己处理
	    @device.status = assign_type
	    #根据分配类型,设置是否有借用天数
	    if assign_type.to_i == 5 || assign_type.to_i == 7
	      @device.borrow_timeleft = borrow_timeleft   #借用时间,再这设置为借用剩余时间,最后定时任务,每天自动减1,当时间为0,提醒管理员收回电脑
	    else
	      @device.borrow_timeleft = -1  #-1代表不会到期
	    end
		
	    @device.assign_time = Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")
	    @device.is_assign = 1
	    
	    @devicerecord = Devicerecord.new
	    @devicerecord.user_id = user_id
	    @devicerecord.device_id = @device.id
	    @devicerecord.note = device_status @device.status

	    if @device.save && @devicerecord.save
	    	return render js: "$('#error-infoassign').html('分配成功#{@device.asset_code}').css('display','block');"#保存成功使用js刷新页面
	    else
	    	return render js: "$('#error-infoassign').html('没有分配成功').css('display','block');"
	    end
	end





#------------------------------------------------------------------------------------------------------------------------------------------

  private
    def device_params
    	params.require(:device).permit(:asset_name, :service_sn, :decategory_id, :release_date, :asset_details)
    end

    def getassetcode(decategory_id)
    	decategory = Decategory.find decategory_id
    	decategorycode = decategory.decategorycode

    	devices = Device.where(decategory_id: decategory_id)
    	num = devices.count + 1
    	time = Time.now
    	return 'YK' + time.month.to_s + time.day.to_s + '-' + decategorycode + '-' + num.to_s
    end
end
