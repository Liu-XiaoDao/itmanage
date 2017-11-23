class UsersController < ApplicationController

  layout 'home'

  def index
  	@users = User.all.paginate page: params[:page], per_page: 10
    @departments = Department.all
  end

  def new
    @user = User.new
    @departments = Department.all
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to users_path
    else
      @departments = Department.all
      render :new
    end
  end

  def search
    # @users = User.where(username: params[:username]).paginate page: params[:page], per_page: 10
    # return render plain: params[:user][:username] + params[:user][:email] + params[:user][:created_at] + params[:user][:department]
    @username = params[:user][:username]
    @email = params[:user][:email]
    @created_at = params[:user][:created_at]
    @department = params[:user][:department]

    @users = User.where("username = ? or email = ? or created_at = ? or department_id = ?",@username,@email,@created_at,@department).paginate page: params[:page], per_page: 10
    @departments = Department.all
    render "index"
  end

  def edit
    @user = User.find(params[:id])
    @decategorys = Decategory.all
    # @devices = Device.where user_id: @user.id
    @devices = @user.devices
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      render json: user_params
    else
      @user.errors.full_messages.each do |msg|
        render plain: msg
      end
    end
#    render :edit
  end

  def updatepw    #管理员修改密码
    @user = User.find(params[:id])
    @user.password = params[:user][:password]
    @user.save
  end

  def upload_avatar
    @user = User.find(params[:id])
    @user.avatar_upload(params[:user][:avatar])

    redirect_to edit_user_path(@user)
  end



  def assigndevise
    #使用设备id拿到设备
    device = Device.find params[:device][:device_id]


    #下面注释,因为报废时间根据出厂时间定,所以不用在这里计算
    # #等于1,表示是新添加设备之前从未有人使用,第一次分配时要,设置4年的报废时间
    # if device.status == 1
    #   device.first_date = Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")
    #   fouryear = Time.zone.now + 4.years
    #   fouryear = fouryear.strftime("%Y-%m-%d %H:%M:%S")
    #   device.scrap_date = fouryear
    # end

    #分配设备,设备的user_id设置为当前用户的id
    device.user_id = params[:id]
    #分配设备是设备的状态只有两种借用或者办公用,其他状态在设备页自己处理
    device.status = params[:device][:assigntype]
    #根据分配类型,设置是否有借用天数
    if params[:device][:assigntype].to_i == 5
      device.borrow_timeleft = params[:device][:borrowtime]   #借用时间,再这设置为借用剩余时间,最后定时任务,每天自动减1,当时间为0,提醒管理员收回电脑
    else
      device.borrow_timeleft = -1  #-1代表不会到期
    end

    device.assign_time = Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")
    device.is_assign = 1
    # return render json: params
    device.save
    redirect_to edit_user_path(params[:id])
  end


  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to users_path
  end

  private
    def user_params
      params.require(:user).permit(:username, :attendance, :email, :department_id)
    end
end
