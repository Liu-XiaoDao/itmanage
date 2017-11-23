class DevicesController < ApplicationController

	layout 'home'


	def index
		@devices = Device.all.paginate page: params[:page], per_page: 10
		@departments = Department.all
		@decategorys = Decategory.all
		@users = User.all
		@status = YAML.load_file("#{Rails.root}/config/status.yml")

		# address = status['address']  
		# render json: @status
	end

	def search
	    @decategory_id = params[:device][:decategory_id]
	    @user_id = params[:device][:user_id]
	    @status_id = params[:device][:status_id]
	    @scrap_date = params[:device][:scrap_date]

	    if @decategory_id.blank? && @user_id.blank? && @status_id.blank? && @scrap_date.blank?
	    	redirect_to devices_path
	    else
	    	@devices = Device.where("decategory_id = ? or user_id = ? or status = ? or scrap_date = ?",@decategory_id,@user_id,@status_id,@scrap_date).paginate page: params[:page], per_page: 10

			@departments = Department.all
			@decategorys = Decategory.all
			@users = User.all
			@status = YAML.load_file("#{Rails.root}/config/status.yml")

		    render "index"
	    end

		    
  end

	def new
		@device = Device.new
		@devices = Device.all
		@decategorys = Decategory.all
	end

	def batchadd
		@device = Device.new
		@decategorys = Decategory.all
	end

	def create
		# return render json: device_params
		# @user = User.find 1
		@device = Device.new(device_params)

		if @device.save
			redirect_to devices_path
		else

		end

	end

	def batchcreate

		devicecount = params[:device][:count].to_i
		if devicecount <= 0
			devicecount = 0
		end
errorinfo = ""
		i = 0
		while i < devicecount  do
		   device = Device.new
		   device.asset_name = params[:device][:name]
		   device.asset_code = getassetcode(params[:device][:decategory_id])
		   device.release_date = params[:device][:release_date]
		   device.decategory_id = params[:device][:decategory_id]
		   device.save

		   errorinfo += device.asset_code
		   # if device && device.errors.any? 
			  # errorinfo += device.errors.full_messages[0]
		   # end 


		   i +=1
		end

# render plain: errorinfo
		redirect_to devices_path



	end

	def edit
		@device = Device.find params[:id]
		@devices = Device.all
		@decategorys = Decategory.all
	end


	def update
	    @device = Device.find(params[:id])

	    if @device.update(device_params)
	      	redirect_to devices_path
	    else
	      	render 'edit'
	    end
  	end

  	def destroy
	    @device = Device.find(params[:id])
		@device.destroy

	    redirect_to devices_path
  	end


  	def ajaxgetdevice
  		@devices = Device.where(decategory_id: params[:decategoryid], is_assign: 0)
	    render json: @devices
  	end


  	def show
  		@device = Device.find(params[:id])  #当前设备
  		@cdevices = @device.cdevices   #从属设备
  		@mdevice = @device.mdevice    #属于哪个设备

  		@user = @device.user   #设备的使用人
  		@decategorys = Decategory.all     #设备分类,拿到所有分类

  		@departments = Department.all

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

	def assigndevise
		# return render json: params
		#分配数据完整性验证
		user_id = params[:device][:user_id]  #用户id
		assign_type = params[:device][:assigntype]  #分配方式(设备状态)
		borrow_timeleft = params[:device][:borrowtime]
		if user_id.blank? || assign_type.blank? || ( assign_type.to_i == 4 && borrow_timeleft.blank?) 
			return render js: "$('#error-info').html('信息不全').css('display','block');"
		end
	    #使用设备id拿到设备
	    @device = Device.find params[:id]
		
	    #等于0,表示是新添加设备之前从未有人使用,第一次分配时要,设置4年的报废时间
	    if @device.status == 0
	      @device.first_date = Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")
	      fouryear = Time.zone.now + 4.years
	      fouryear = fouryear.strftime("%Y-%m-%d %H:%M:%S")
	      @device.scrap_date = fouryear
	    end
		
	    #分配设备,设备的user_id设置为当前用户的id
	    @device.user_id = params[:device][:user_id]
	    #分配设备是设备的状态只有两种借用或者办公用,其他状态在设备页自己处理
	    @device.status = params[:device][:assigntype]
	    #根据分配类型,设置是否有借用天数
	    if params[:device][:assigntype].to_i == 4
	      @device.borrow_timeleft = params[:device][:borrowtime]   #借用时间,再这设置为借用剩余时间,最后定时任务,每天自动减1,当时间为0,提醒管理员收回电脑
	    else
	      @device.borrow_timeleft = -1  #-1代表不会到期
	    end
		
	    @device.assign_time = Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")
	    @device.is_assign = 1
	    # return render json: params
	    
	    if @device.save
	    	redirect_to device_path(params[:id])
	    else
	    	
	    end

	    
	end

	def appenddevice
		append_department_id = params[:device][:department_id]   #选中设备的id
		if append_department_id.blank?
			return render plain: "没有选择设备"
		end

		@device = Device.find params[:id] #当前设备
		@append_device = Device.find append_department_id #当前设备
		@append_device.belong_to = @device.id   #设备属于另外哪一个设备

		@append_device.is_assign = 1
		@append_device.assign_time = Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")

	    #等于0,表示是新添加设备之前从未有人使用,第一次分配时要,设置4年的报废时间
	    if @append_device.status == 0
	      @append_device.first_date = Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")
	      fouryear = Time.zone.now + 4.years
	      fouryear = fouryear.strftime("%Y-%m-%d %H:%M:%S")
	      @append_device.scrap_date = fouryear
	    end

	    @append_device.status = 9 #状态为从属于别的设备,然后就忽略一些信息

		# @append_device.user_id = @device.user_id
		# @append_device.borrow_timeleft = @device.borrow_timeleft
		# @append_device.managed_by = @device.managed_by
		if @append_device.save
	    	redirect_to device_path(params[:id])
	    else
	    	return render plain: "append失败"
	    end

	end


  private
    def device_params
    	params.require(:device).permit(:asset_code, :asset_name, :service_sn, :decategory_id, :release_date, :asset_details)
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
