class UsersController < ApplicationController

  layout 'home'

  def index
  	@users = User.all.paginate page: params[:page], per_page: 10
    @departments = Department.all

    #导出Excel的.一会在研究
    if params[:format]
      export_csv(User)
    end
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



  #搜索设备
  def search


    @username = params[:user][:username]
    @email = params[:user][:email]
    @created_at = params[:user][:created_at]
    @department_id = params[:user][:department_id]

    if @username.blank? && @email.blank? && @created_at.blank? && @department_id.blank?
      redirect_to users_path
    else
      searchstr = ''

      if !@username.blank?
        searchstr += "username like '%#{@username}%'"
      end

      if !@email.blank?
        andstr = searchstr.blank? ? "" : " and "
        searchstr = searchstr + andstr
        searchstr += "email like '%#{@email}%'"
      end

      if !@department_id.blank?
        andstr = searchstr.blank? ? "" : " and "
        searchstr = searchstr + andstr
        searchstr += "department_id = #{@department_id}"
      end

      if !@created_at.blank?
        andstr = searchstr.blank? ? "" : " and "
        
        begindate = Time.parse(@created_at) - 1.months
        enddate = Time.parse(@created_at) + 1.months

        searchstr = searchstr + andstr
        searchstr += "created_at between '#{begindate.try(:strftime, '%Y-%m-%d')}' And '#{enddate.try(:strftime, '%Y-%m-%d')}'"
      end
      @users = User.where(searchstr).paginate page: params[:page], per_page: 10

      @departments = Department.all
# return render plain: searchstr
      render "index"

    end
  end

  #用户详情
  def edit
    @user = User.find(params[:id])
    @decategorys = Decategory.all
    # @devices = Device.where user_id: @user.id
    @devices = @user.devices
    @consumables = Consumable.all
    @consumablerecords = @user.consumablerecords

    #用户的所有设备使用记录
    @devicerecords = @user.devicerecords

    # @myconsumables = @user.consumables   这个是测试用户所有耗材的
    # render json: @myconsumables
  end


  #这个没有使用
  def show
    @user = User.find(params[:id])
  end


  #修改用户信息,现在能改的是考勤号和名字
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

  #管理员修改密码
  def updatepw    
    @user = User.find(params[:id])
    @user.password = params[:user][:password]
    @user.save
  end

  #用户上传头像
  def upload_avatar
    @user = User.find(params[:id])
    @user.avatar_upload(params[:user][:avatar])

    redirect_to edit_user_path(@user)
  end


  #在用户详情页给用户分配设备
  def assigndevise

    #使用设备id拿到设备
    @device = Device.find params[:device][:device_id]


    #下面注释,因为报废时间根据出厂时间定,所以不用在这里计算
    # #等于1,表示是新添加设备之前从未有人使用,第一次分配时要设置第一次分配时间,四年的报废不用设置了....{,设置4年的报废时间}
    if @device.status == 1
      @device.first_date = Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")
      # fouryear = Time.zone.now + 4.years
      # fouryear = fouryear.strftime("%Y-%m-%d %H:%M:%S")
      # device.scrap_date = fouryear
    end

    #分配设备,设备的user_id设置为当前用户的id
    @device.user_id = params[:id]
    #分配设备是设备的状态只有两种借用或者办公用,其他状态在设备页自己处理
    @device.status = params[:device][:assigntype]
    #根据分配类型,设置是否有借用天数
    if params[:device][:assigntype].to_i == 5
      @device.borrow_timeleft = params[:device][:borrowtime]   #借用时间,再这设置为借用剩余时间,最后定时任务,每天自动减1,当时间为0,提醒管理员收回电脑
    else
      @device.borrow_timeleft = -1  #-1代表不会到期
    end

    @device.assign_time = Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")
    @device.is_assign = 1
    # return render json: params
    
    @devicerecord = Devicerecord.new
    @devicerecord.user_id = @device.user_id
    @devicerecord.device_id = @device.id
    @devicerecord.note = device_status @device.status


    if @device.save && @devicerecord.save
      redirect_to edit_user_path(params[:id])
    else
      
    end

  end

  #删除用户,,这里还需操作.删除用户时,用户的设备处理问题
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to users_path
  end

  #给用户分配耗材
  def assignconsumable
    @user = User.find(params[:id])
    @consumable_id = params[:consumable_id]

    @consumable = Consumable.find @consumable_id
    @consumable.used_amount = @consumable.used_amount.to_i + 1
    @consumable.surplus_amount = @consumable.surplus_amount.to_i - 1
    @consumable.save

    @consumablerecord = Consumablerecord.new
    @consumablerecord.user_id = @user.id
    @consumablerecord.consumable_id = @consumable_id
    @consumablerecord.note = "分配"
    @consumablerecord.save

    redirect_to edit_user_path(@user)
  end




  def upload
    

    @users = params[:users].split("\r\n")
    count = 0
    @users.each do |user|
      userarr = user.split(",")
      department = Department.find_by department_name: userarr[3]
      useritem = User.new
      useritem.username = userarr[0]
      useritem.email = userarr[1]
      useritem.attendance = userarr[2]
      useritem.department_id = department.blank? ? 0 : department.id
      useritem.save!
    end

    render plain: count
  end



  private
    def user_params
      params.require(:user).permit(:username, :attendance, :email, :department_id)
    end
end
