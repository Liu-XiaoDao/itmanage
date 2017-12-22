class UsersController < ApplicationController

  layout 'home'

  def index
    @users = User.all.order(id: :desc).paginate page: params[:page], per_page: 15
    @departments = Department.alltree
    #导出Excel的.一会在研究
    if params[:format]
      export_csv(User)
    end
  end
  #添加新员工页面
  def new
    @user = User.new
    # @departments = Department.alltree

    @decategorydevices = Department.joins("INNER JOIN departments as b ON departments.id = b.parent_id ").select('id').distinct

    @departments = Department.where.not(id: @decategorydevices.collect{|decategorydevice| decategorydevice.id }).order('pgcode')
  end

  #保存新员工
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "新员工创建成功"
      redirect_to users_path
    else
      @departments = Department.alltree
      render :new
    end
  end

  #搜索员工
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
      @departments = Department.alltree

      render "index"
    end
  end

  #用户详情
  def edit
    @user = User.find(params[:id])
    # @departments = Department.alltree

    @decategorydevices = Department.joins("INNER JOIN departments as b ON departments.id = b.parent_id ").select('id').distinct
    @departments = Department.where.not(id: @decategorydevices.collect{|decategorydevice| decategorydevice.id }).order('pgcode')
  end


  #员工详情页面
  def show
    @user = User.find(params[:id])
    @decategorys = Decategory.alltree
    @devices = @user.devices
    @consumables = Consumable.all
    @consumablerecords = @user.consumablerecords
    #用户的所有设备使用记录
    @devicerecords = @user.devicerecords

    #用户所拥有的所有授权
    @authorizations = @user.authorizations

    @departments = Department.all
  end

  #show页面修改用户信息
  def showupdate
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "员工修改成功"
      redirect_to user_path(@user)
    else
      flash[:danger] = "员工修改失败"
      redirect_to user_path(@user)
    end 
  end


  #修改用户信息,现在能改的是考勤号和名字
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "员工修改成功"
      redirect_to users_path
    else
      @departments = Department.alltree
      render :edit
    end 
  end

  #管理员修改密码
  def updatepw
    @user = User.find(params[:id])
    @user.password = params[:user][:password]
    if @user.save
        flash[:success] = "密码修改成功"
        return render js: "location.reload();"#保存成功使用js刷新页面
    else
        return render js: "$('#error-infoassign').html('密码修改失败').css('display','block');"
    end
  end

  #用户上传头像   上传头像功能取消
  # def upload_avatar
  #   @user = User.find(params[:id])
  #   @user.avatar_upload(params[:user][:avatar])
  #   redirect_to user_path(@user)
  # end


  #在用户详情页给用户分配设备
  def assigndevise
    assign_type = params[:device][:assigntype]  #分配方式(设备状态)
    borrow_timeleft = params[:device][:borrowtime]
    device_id = params[:device][:device_id]

    if device_id.blank? || assign_type.blank? || ( assign_type.to_i == 5 && borrow_timeleft.blank?) || ( assign_type.to_i == 7 && borrow_timeleft.blank?)  
      flash[:danger] = "设备分配失败,信息不全"
      return redirect_to user_path(params[:id])
    end
    #使用设备id拿到设备
    @device = Device.find device_id
    #下面注释,因为报废时间根据出厂时间定,所以不用在这里计算
    # #等于1,表示是新添加设备之前从未有人使用,第一次分配时要设置第一次分配时间,四年的报废不用设置了....{,设置4年的报废时间}
    if @device.status == 1
      @device.first_date = Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")
    end

    #分配设备,设备的user_id设置为当前用户的id
    @device.user_id = params[:id]
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

    @devicerecord = Devicerecord.new
    @devicerecord.user_id = @device.user_id
    @devicerecord.device_id = @device.id
    @devicerecord.note = device_status @device.status

    if @device.save && @devicerecord.save
      flash[:success] = "设备分配成功"
      return redirect_to user_path(params[:id])
    else
      flash[:danger] = "设备分配失败" + (@device.errors.any? ? @device.errors.full_messages[0] : "11")
      return redirect_to user_path(params[:id])
    end
  end

  #删除用户,,这里还需操作.删除用户时,用户的设备处理问题
  def destroy
    @user = User.find(params[:id])

    if @user.devices.blank? && @user.consumablerecords.blank? && @user.devicerecords.blank? && @user.authorization_user_devices.blank?
      @user.destroy
      flash[:success] = "用户删除成功"
      redirect_to users_path
    else
      flash[:danger] = "用户用过操作记录不能删除"
      redirect_to users_path      
    end
      
  end

  #给用户分配耗材
  def assignconsumable
    if params[:id].blank? || params[:consumable_id].blank?
      flash[:danger] = "设备分配失败,信息不全"
      return redirect_to request.referrer || users_path
    end

    @user = User.find(params[:id])
    @consumable_id = params[:consumable_id]

    @consumable = Consumable.find @consumable_id
    @consumable.used_amount = @consumable.used_amount.to_i + 1
    @consumable.surplus_amount = @consumable.surplus_amount.to_i - 1
    

    @consumablerecord = Consumablerecord.new
    @consumablerecord.user_id = @user.id
    @consumablerecord.consumable_id = @consumable_id
    @consumablerecord.note = "分配"

    if @consumable.save && @consumablerecord.save
      flash[:success] = "耗材分配成功"
      return redirect_to user_path(@user)
    else
      flash[:danger] = "耗材分配失败"
      return redirect_to user_path(@user)
    end
  end

  #倒入用户方法
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
      params.require(:user).permit(:username, :attendance, :email, :department_id, :position)
    end
end

#去除\ufeff方法,注意使用我的作为基准,所以刘青新,刘小龙,会多去点一个字符原因未知

  # def index
  #   @seconduser = User.second
  #   tsstr = @seconduser.username[0]
  #   @users = User.all
  #   strprenext = ''
  #   @users.each do |user|
  #       strprenext = strprenext + user.username + "----"
  #       user.username = user.username.delete(tsstr)
  #       user.save
  #       strprenext = strprenext + user.username + '\n'
  #   end
  #   render plain: strprenext.inspect
  # end
