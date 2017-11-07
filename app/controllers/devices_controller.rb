class DevicesController < ApplicationController

	layout 'home'


	def index
		@devices = Device.all
		@departments = Department.all
	end

	def new
		@device = Device.new
		@devices = Device.all
		@decategorys = Decategory.all
	end

	def create
		# return render json: device_params
		@user = User.find 1
		@device = Device.new(device_params)

		if @device.save
			redirect_to devices_path
		else

		end

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

		# def assigndevise
	  #   #使用设备id拿到设备
	  #   device = Device.find params[:device][:department_id]
		#
	  #   #等于0,表示是新添加设备之前从未有人使用,第一次分配时要,设置4年的报废时间
	  #   if device.status == 0
	  #     device.first_date = Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")
	  #     fouryear = Time.zone.now + 4.years
	  #     fouryear = fouryear.strftime("%Y-%m-%d %H:%M:%S")
	  #     device.scrap_date = fouryear
	  #   end
		#
	  #   #分配设备,设备的user_id设置为当前用户的id
	  #   device.user_id = params[:id]
	  #   #分配设备是设备的状态只有两种借用或者办公用,其他状态在设备页自己处理
	  #   device.status = params[:device][:assigntype]
	  #   #根据分配类型,设置是否有借用天数
	  #   if params[:device][:assigntype].to_i == 4
	  #     device.borrow_timeleft = params[:device][:borrowtime]   #借用时间,再这设置为借用剩余时间,最后定时任务,每天自动减1,当时间为0,提醒管理员收回电脑
	  #   else
	  #     device.borrow_timeleft = -1  #-1代表不会到期
	  #   end
		#
	  #   device.assign_time = Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")
	  #   device.is_assign = 1
	  #   # return render json: params
	  #   device.save
	  #   redirect_to edit_user_path(params[:id])
	  # end


  private
    def device_params
      params.require(:device).permit(:asset_code, :asset_name, :service_sn, :decategory_id, :receive_date, :asset_details, :belong_to, :status)
    end
end
