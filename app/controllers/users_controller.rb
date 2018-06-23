class UsersController < ApplicationController

  layout 'home'

  def index
    @search = User.ransack(params[:q])
    @users  = @search.result.order(is_quit: :asc,id: :desc).paginate page: params[:page], per_page: 15
    # @users = User.all.order(is_quit: :asc,id: :desc).paginate page: params[:page], per_page: 15

    @departments = Department.leafdepartment
    #导出Excel的.一会在研究
    if params[:format]
      export_csv(User)
    end
  end
  #导出报表
  def export_csv(model)
    respond_to { |format|
      format.html
      format.xlsx { send_data model.to_xlsx(model.all).stream.string, filename: "users.xlsx", disposition: 'attachment' }
    }
  end
  #添加新员工页面
  def new
    @user = User.new
    @departments = Department.leafdepartment
    #所有权限
    @roles = Role.all
  end

  #保存新员工
  def create
    @user = User.new(user_params)
    if @user.save

      #用户所属角色设置
      @params_roles = Role.where(id: params[:roles])
      @params_roles.each do |add_role|
        userrole = UserRole.create(user_id: @user.id, role_id: add_role.id)
      end

      flash[:success] = "新员工创建成功"
      redirect_to users_path
    else
      @departments = Department.leafdepartment
      #所有权限
      @roles = Role.all
      render :new
    end
  end


  #用户详情
  def edit
    @user = User.find(params[:id])
    @departments = Department.leafdepartment
    #所有权限和用户拥有权限
    @roles = Role.all
    @my_roles = @user.roles
  end

  #员工详情页面
  def show
    @user = User.find(params[:id])
    @decategorys = Decategory.leafdecategory
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
    #用户所属角色设置
    @my_roles = @user.roles
    @params_roles = Role.where(id: params[:roles])
    @delete_roles = @my_roles - @params_roles
    @delete_roles.each do |delete_role|
      UserRole.where(role_id: delete_role.id, user_id: @user.id).first.destroy
    end
    @add_roles = @params_roles - @my_roles
    @add_roles.each do |add_role|
      userrole = UserRole.create(user_id: @user.id, role_id: add_role.id)
    end
    #用户属性修改
    if @user.update(user_params)
      flash[:success] = "员工修改成功"
      redirect_to users_path
    else
      @departments = Department.leafdepartment
      #所有权限和用户拥有权限
      @roles = Role.all
      @my_roles = @user.roles
      render :edit
    end
  end

  #管理员修改密码
  # def updatepw
  #   @user = User.find(params[:id])
  #   @user.password = params[:user][:password]
  #   if @user.save
  #       flash[:success] = "密码修改成功"
  #       return render js: "location.reload();"#保存成功使用js刷新页面
  #   else
  #       return render js: "$('#error-infoassign').html('密码修改失败').css('display','block');"
  #   end
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
    if params[:device][:assigntype].to_i == 3 || params[:device][:assigntype].to_i == 4
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

  def quit#离职
    @user = User.find(params[:id])

    if @user.devices.blank?  && @user.authorization_user_devices.blank?
      @user.is_quit = 1
      if @user.save
        flash[:success] = "用户成功离职"
        redirect_to @user
      else
        flash[:danger] = "用户离职失败"
        redirect_to @user
      end
    else
      flash[:danger] = "用户还有未回收设备,不能离职"
      redirect_to @user
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
      userarr = user.strip.split("\t")
      #department = Department.where("department_name = '#{userarr[2]}' and parent_id != 0").last
      #useritem = User.new
      #useritem.username = userarr[0]
      #useritem.email = "#{rand(99999999)}@abcam.com"
      #useritem.attendance = userarr[1]
      #useritem.position = userarr[3]
      #useritem.department_id = department.blank? ? 0 : department.id
      #useritem.save!

      ruser = User.find_by username: userarr[0]
      #return render json: userarr[0].strip
      if ruser.present?
        ruser.email = userarr[1]
        ruser.save!
        count = count + 1
      end
    end
    render plain: count
  end

  def upload_user_list
    # return render plain: params[:user_list][:user_list].original_filename
    if !file_param
      redirect_to :back, alert: "You need select a file"
    else
      @users = User.import_preview(file_param)
      @users_cache_key = "users#{SecureRandom.hex}"
      puts @users_cache_key
      Rails.cache.write(@users_cache_key, @users, expires_in: 1.days)
    end
  end

  def import_user_list
    up, cr, er = 0, 0, 0
    @users = Rails.cache.read(params[:users_cache_key])
    puts params[:users_cache_key]
    binding.pry
    return render json: @users
    @users[:update_record].map do |t|
      t.save ? up += 1 : er += 1
    end
    @users[:create_record].each do |t|
      unless User.exists?(id: t.id)
        t.save ? cr += 1 : er += 1
      end
    end
    Rails.cache.delete(params[:users_cache_key])
    info = (er == 0) ? :notice : :alert
    flash[info] = "create: " + cr.to_s + " update: " + up.to_s + " error: " + er.to_s
    redirect_to users_url
  end

  private
    def user_params
      params.require(:user).permit(:username, :email, :department_id, :position)
    end

    def file_param
      params[:user_list][:user_list]
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
