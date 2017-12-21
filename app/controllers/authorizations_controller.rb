class AuthorizationsController < ApplicationController
	layout 'home'
	def index
		@authorizations = Authorization.all.paginate page: params[:page], per_page: 20
	end

	def new
		@authorization = Authorization.new
	end

	def create
		@authorization = Authorization.new(authorization_params)
		@authorization.available_quantity = @authorization.amount
		if @authorization.save
			flash[:success] = "授权增加成功"
			redirect_to authorizations_path
		else
			render :new
		end
	end

	def edit
		@authorization = Authorization.find params[:id]
	end

	def update
		@authorization = Authorization.find params[:id]
		if @authorization.update(authorization_params)
			flash[:success] = "授权修改成功"
			redirect_to authorizations_path
		else
			render :edit
		end
	end

	def show
		@authorization = Authorization.find params[:id]
		@authorizationdevices = @authorization.devices
		@authorizationusers = @authorization.users

		@devices = Device.all
		@users = User.all
	end

	def award
		@authorization = Authorization.find params[:id]
		if @authorization.available_quantity <= 0
			return render js: "$('#error-info').html('授权许可数量已用光,如有需要请重新申请授权').css('display','block');"
		end
		@authorization.available_quantity = @authorization.available_quantity - 1


		@authorizationuserdevice = AuthorizationUserDevice.new
		@authorizationuserdevice.user_id = params[:authorization][:user_id]
		@authorizationuserdevice.device_id = params[:authorization][:device_id]
		@authorizationuserdevice.authorization_id = params[:id]
		@authorizationuserdevice.note = "授权"


		if @authorizationuserdevice.save && @authorization.save
			flash[:success] = "授权成功"
	    	return render js: "location.reload();"#保存成功使用js刷新页面
		else
			errorinfo = @authorizationuserdevice.errors.full_messages[0]
			return render js: "$('#error-info').html('授权失败: #{errorinfo}').css('display','block');"
		end
	end
	#从设备上回收授权
	def recycledevice
		@authorizationuserdevice = AuthorizationUserDevice.where(authorization_id: params[:id],device_id: params[:did]).first
# return render json: @authorizationuserdevice
		@authorization = Authorization.find params[:id]
		@authorization.available_quantity = @authorization.available_quantity + 1

		if @authorization.save && @authorizationuserdevice.destroy
			flash[:success] = "授权回收成功"
			redirect_to authorization_path(@authorization)
		else
			flash[:danger] = "授权回收失败"
			redirect_to authorization_path(@authorization)
		end
	end
	#从用户上回收授权
	def recycleuser
		@authorizationuserdevice = AuthorizationUserDevice.where(authorization_id: params[:id],user_id: params[:uid]).first
# return render json: @authorizationuserdevice
		@authorization = Authorization.find params[:id]
		@authorization.available_quantity = @authorization.available_quantity + 1

		if @authorization.save && @authorizationuserdevice.destroy
			flash[:success] = "授权回收成功"
			redirect_to authorization_path(@authorization)
		else
			flash[:danger] = "授权回收失败"
			redirect_to authorization_path(@authorization)
		end
		
	end

	def destroy
		@authorization = Authorization.find params[:id]

		if @authorization.authorization_user_devices.blank?
			@authorization.destroy
			flash[:success] = "授权删除成功"
			redirect_to authorizations_path
		else
			flash[:danger] = "授权删除失败"
			redirect_to authorizations_path
		end
		
	end

	private
		def authorization_params
			params.require(:authorization).permit(:name, :serial_number, :key, :begin_date, :end_date, :amount, :price, :manufacturer, :contact_information)
		end
end
