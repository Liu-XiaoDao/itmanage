class DevicesController < ApplicationController
  layout 'home'
  #设备列表
  def index
    @search = Device.ransack(params[:q])
    #设备列表显示is_delete为0的设备
    @devices = @search.result.order(is_delete: :asc, is_scrap: :asc, id: :desc).paginate page: params[:page], per_page: 20
    #搜索使用部门
    @departments = Department.leafdepartment
    #搜索使用设备分类
    @decategorys = Decategory.leafdecategory
    #搜索使用员工
    @users = User.all
    #从yml文件中拿到设备的所有状态
    @status = YAML.load_file("#{Rails.root}/config/status.yml")['device']

    respond_to { |format|
        format.html
        format.xlsx { send_data Device.to_xlsx(Device.all).stream.string, filename: "devices.xlsx", disposition: 'attachment' }
      }
  end

    #添加设备试图
  def new
    @device = Device.new
    @decategorys = Decategory.leafdecategory
  end

  #添加设备
  def create
    #新建设备 device_params内容包括:asset_name, :service_sn, :decategory_id, :release_date, :asset_details
    @device = Device.new(device_params)
    #设备维保到期时间
    @device.scrap_date = Time.parse(@device.release_date.try(:strftime, "%Y-%m-%d")) + params[:device][:guaranteed].to_i.months - 1.day
    #保存
    if @device.save
      flash[:success] = "设备增加成功"
      redirect_to devices_path
    else
      @decategorys = Decategory.leafdecategory
      render :new
    end
  end

  #批量添加界面
  def batchadd
    @device = Device.new
    @decategorys = Decategory.leafdecategory
  end

  #批量添加设备
  def batchcreate
    #批量添加的数量
    devicecount = params[:device][:count].to_i
    #如果小于等于0,就设置为0
    if devicecount <= 0
      devicecount = 0
    end
       #用i做循环计数
    i = 0
    while i < devicecount  do
      device = Device.new
      device.asset_name = params[:device][:name]#设备名
      device.asset_code = getassetcode(params[:device][:decategory_id])#设备编号自动生成,可能要改
      device.release_date = params[:device][:release_date]#设备出厂日期
      device.decategory_id = params[:device][:decategory_id]#设备类型
      device.asset_details = params[:device][:asset_details]#设备详情
      #设备维保到期时间
      device.scrap_date = Time.parse(device.release_date.try(:strftime, "%Y-%m-%d")) + params[:device][:guaranteed].to_i.months - 1.day
      #保存
      unless device.save
        flash[:danger] = "设备批量添加失败: 第#{i}个开始失败"
        return redirect_to devices_path
      end
      i +=1
    end
    flash[:success] = "设备批量添加成功,添加数量#{i}个"
    redirect_to devices_path
  end

  #修改设备
  def edit
    #拿到设备
    @device = Device.find params[:id]
    #拿到所有设备
    @decategorys = Decategory.leafdecategory
  end


  def update
    #拿到要修改的设备
    @device = Device.find(params[:id])
    #因为有过维保的设备就不嫩在修改出厂和维保到期时间,所以在这里保存的时候要注意区分
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
      flash[:success] = "设备信息修改成功"
      redirect_to devices_path
    else
      #拿到所有设备
      @decategorys = Decategory.leafdecategory
      render 'edit'
    end
  end

    def showupdate
      #拿到设备
      @device = Device.find(params[:id])
      #拿到show页面修改时的属性
      device_params = params.require(:device).permit(:asset_name, :service_sn, :decategory_id, :asset_details, :location)
      #保存
      if @device.update(device_params)
        flash[:success] = "修改成功"
          redirect_to device_path(@device)
      else
        flash[:danger] = "修改失败: " + (@device.errors.any? ? @device.errors.full_messages[0] : "")
          redirect_to device_path(@device)
      end
    end

    def clear
      @device = Device.find params[:id]
      if @device.user.present? || @device.is_assign?
        flash[:danger] = "设备正在使用或者未报废不能清理"
        redirect_to request.referer
        return
      end
      @device.is_delete = 1
      if @device.save
        flash[:success] = "设备清理成功"
        redirect_to request.referer
      else
        flash[:danger] = "设备清理失败"
        redirect_to request.referer
      end
    end

    #删除,但是因为其他表的外键依赖,所以添加is_delete属性,删除的话此属性设置为1
    def destroy
      @device = Device.find(params[:id])
      if @device.parts.blank? && @device.deviceservices.blank? && @device.devicerecords.blank? && @device.authorization_user_devices.blank?
        @device.destroy
        flash[:success] = "设备删除成功"
        redirect_to devices_path
      else
        flash[:danger] = "设备有过操作记录不能删除"
        redirect_to devices_path
      end
    end

  #用户详情页中分配设备是ajax获得设备的方法
    def ajaxgetdevice
      @devices = Device.where(decategory_id: params[:decategoryid], is_assign: 0, is_delete: 0)#返回未分配的未清理的即可
      render json: @devices
    end

    #在配件show中的附加到设备方法使用(ajax获得)
    #因为不管是已分配未分配,或者是维保到期设备都能添加配件,所以只根据类别拿到所有设备
    def ajaxgetalldevice
      @devices = Device.where(decategory_id: params[:decategoryid])
      render json: @devices
    end

    #设备详情页
    def show
      @device = Device.find(params[:id])  #拿到当前设备
      @parts = @device.parts   #当前设备的所有配件
      @user = @device.user   #当前设备的使用人

      @decategorys = Decategory.leafdecategory     #设备分类,拿到所有分类
      @partcategorys = Partcategory.leafpartcategory     #配件分类,拿到所有分类
      @departments = Department.leafdepartment #所有部门,详情页中分配设备时会用到

      @devicerecords = @device.devicerecords   #当前设备的分配记录
      #设备拥有的所有权限
      @authorizations = @device.authorizations
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


    #分配设备(user控制器中也有应该提取出来)--------这个是设备详情页中的分配
  def assigndevise
    #分配数据完整性验证
    user_id = params[:device][:user_id]  #用户id
    assign_type = params[:device][:assigntype]  #分配方式(设备状态)
    borrow_timeleft = params[:device][:borrowtime]
    if user_id.blank? || assign_type.blank? || ( assign_type.to_i == 3 && borrow_timeleft.blank?) || ( assign_type.to_i == 4 && borrow_timeleft.blank?)
      return render js: "$('#error-infoassign').html('信息不全,请重新分配,注意信息完整').css('display','block');"
    end
      #使用设备id拿到设备
      @device = Device.find params[:id]
      #等于1,表示是新添加设备之前从未有人使用,第一次分配时要,设置第一次分配时间,原本还要设置报废时间,但是报废时间不根据第一次分配时间设置,所以这里取消掉这个逻辑{{4年的报废时间}}
      if @device.status == 1
        @device.first_date = Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")
      end
      #分配设备,设备的user_id设置为当前用户的id
      @device.user_id = user_id
      #分配设备是设备的状态只有两种借用或者办公用,其他状态在设备页自己处理
      @device.status = assign_type
      #根据分配类型,设置是否有借用天数
      if assign_type.to_i == 3 || assign_type.to_i == 4
        @device.borrow_timeleft = borrow_timeleft   #借用时间,再这设置为借用剩余时间,最后定时任务,每天自动减1,当时间为0,提醒管理员收回电脑
      else
        @device.borrow_timeleft = -1  #-1代表不会到期
      end
    #设备分配时间
      @device.assign_time = Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")
      #是否已分配标记
      @device.is_assign = 1
      #设备分配记录
      @devicerecord = Devicerecord.new
      @devicerecord.user_id = user_id
      @devicerecord.device_id = @device.id
      @devicerecord.note = device_status @device.status
      #如果设备和设备分配记录都能保存成功,就算成功,其实这里应该用事物来保证
      if @device.save && @devicerecord.save
        flash[:success] = "设备分配成功"
        return render js: "location.reload();"#保存成功使用js刷新页面
      else
        return render js: "$('#error-infoassign').html('没有分配成功').css('display','block');"
      end

  end


  #添加配件
  def appendpart
    @device = Device.find params[:id] #当前设备
    #选中配件的id
    append_part_id = params[:part][:part_id]
    #如果没有选择配件
    if append_part_id.blank?
      flash[:danger] = "添加配件失败,没有选择配件"
      return redirect_to device_path(@device)
    end
    #拿到将要被添加的配件
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
    #如果配件和配件分配记录都能保存成功,就算成功,其实这里应该用事物来保证
    if @append_part.save && @partrecord.save
      flash[:success] = "配件添加成功"
      redirect_to device_path(@device)
    else
      flash[:danger] = "配件添加失败"
      redirect_to device_path(@device)
    end

  end


  #设备回收--这个方法在用户show页面调用
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
    #回收设备,设备的状态设置为闲置
    @device.status = 1
    @device.borrow_timeleft = -1  #-1闲置状态下的值

    #回收设备,设备的user_id设置nil
    @device.user_id = nil
    #回收时把分配时间设置成回收时间
    @device.assign_time = Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")
    #这个地方设置成0,这个是区分设备时候被分配,被分配为1,否则为0
    @device.is_assign = 0
    #如果设备回收和设备回收记录都能保存成功,就算成功,其实这里应该用事物来保证
    if @device.save && @devicerecord.save
      flash[:success] = "设备回收成功"
      redirect_to request.referer
    else
      flash[:danger] = "设备回收失败"
      redirect_to request.referer
    end
  end

  #设置设备状态-----应该用不到了
  # def setstatus
  #   #使用设备id拿到设备
  #   @device = Device.find params[:id]
  #   #状态
  #   status = params[:device][:status]
  #
  #   if @device.is_assign == 1
  #     return render js: "$('#error-infoassign').html('当前设备正在被使用不允许设置状态').css('display','block');"
  #   end
  #
  #   if @device.is_scrap == 0
  #     if status == '6' || status == '8'
  #       return render js: "$('#error-infoassign').html('当前设备没有超过维保时间,不能报废或清理').css('display','block');"
  #     end
  #   else
  #     if status == '3' || status == '4'
  #       return render js: "$('#error-infoassign').html('当前设置已经超过维保,请续保后再设置状态').css('display','block');"
  #     end
  #   end
  #
  #   @device.status = status
  #
  #   if @device.save
  #     flash[:success] = "设备状态设置成功"
  #        return render js: "location.reload();"#保存成功使用js刷新页面
  #   else
  #     return render js: "$('#error-infoassign').html('状态设置失败').css('display','block');"
  #   end
  # end

#------------------------------------------------------------------------------------------------------------------------------------------

  private
    def device_params
      params.require(:device).permit(:asset_code, :asset_name, :service_sn, :decategory_id, :release_date, :asset_details)
    end
    #这个方法怎么改下周一再问
    def getassetcode(decategory_id)
      decategory = Decategory.find decategory_id
      decategorycode = decategory.decategorycode

      devices = Device.where(decategory_id: decategory_id)
      num = devices.count + 1
      time = Time.now.strftime('%Y-%m')
      times = time.to_s.gsub('-','')[2..5]
      return 'YK' + times + '-' + decategorycode + '-' + num.to_s
    end
end
