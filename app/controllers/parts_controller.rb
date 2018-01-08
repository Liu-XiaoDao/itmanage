class PartsController < ApplicationController
  layout 'home'
  #显示所有配件
  def index
    #所有配件
    @parts = Part.all.order(id: :desc).paginate page: params[:page], per_page: 15
    #所有配件分类
    @partcategorys = Partcategory.leafpartcategory
    #从配置文件中拿出所有配件状态
    @status = YAML.load_file("#{Rails.root}/config/status.yml")['part']
  end
  #搜索配件
  def search
    #拿到要查找分类
    @partcategory_id = params[:part][:partcategory_id]
    #是否分配
    @assign = params[:part][:assign]
    #拿到想要的配件的状态
    @status_id = params[:part][:status_id]
    #如果都为空就重新渲染
    if @partcategory_id.blank? && @assign.blank? && @status_id.blank?
      redirect_to parts_path
    else
      #搜索字符串
      searchstr = ''
      if !@partcategory_id.blank?
        searchstr += "partcategory_id = #{@partcategory_id}"
      end
      if !@assign.blank?
        andstr = searchstr.blank? ? "" : " and "
        searchstr = searchstr + andstr
        searchstr += "is_assign = #{@assign}"
      end
      if !@status_id.blank?
        andstr = searchstr.blank? ? "" : " and "
        searchstr = searchstr + andstr
        searchstr += "status = #{@status_id}"
      end
      @parts = Part.where(searchstr).paginate page: params[:page], per_page: 15
      #下面是列表页要用的
      @partcategorys = Partcategory.leafpartcategory
      @status = YAML.load_file("#{Rails.root}/config/status.yml")['part']
      render "index"
    end
  end
  #添加设备试图
  def new
    #空实例
    @part = Part.new
    #所有配件分类
    @partcategorys = Partcategory.leafpartcategory
  end
	#添加设备
  def create
    #:partcategory_id, :part_name, :part_details, :receive_date
    @part = Part.new(part_params)
    #自动生成的配件编号,生成配件编号的方法要重新定义
    @part.part_code = getpartcode(params[:part][:partcategory_id])
    #新配件状态为1
    @part.status = 1
    #是否分配为0,表示未分配
    @part.is_assign = 0
    if @part.save
      flash[:success] = "配件添加成功"
      redirect_to parts_path
    else
      #所有配件分类
      @partcategorys = Partcategory.leafpartcategory
      render :new
    end
  end
  #修改配件
  def edit
    @part = Part.find params[:id]
    @partcategorys = Partcategory.leafpartcategory
  end
  #修改
  def update
  	@part = Part.find params[:id]
    if @part.update part_params
      flash[:success] = "配件信息修改成功"
      redirect_to parts_path
    else
      #所有配件分类
      @partcategorys = Partcategory.leafpartcategory
      render :edit
    end
  end
  #配件详情也得修改
  def showupdate
    @part = Part.find params[:id]
    if @part.update part_params
      flash[:success] = "修改成功"
      redirect_to part_path(@part)
    else
      flash[:danger] = "修改失败: " + (@part.errors.any? ? @part.errors.full_messages[0] : "")
      redirect_to part_path(@part)
    end
  end

  #批量添加界面
  def batchadd
    @part = Part.new
    @partcategorys = Partcategory.leafpartcategory
  end

  #批量添加设备
	def batchcreate
		partcount = params[:part][:count].to_i
		if partcount <= 0
			partcount = 0
		end
		i = 0
		while i < partcount  do
		  part = Part.new
		  part.part_name = params[:part][:part_name]
		  part.part_code = getpartcode(params[:part][:partcategory_id])
		  part.receive_date = params[:part][:receive_date]
		  part.part_details = params[:part][:part_details]
		  part.partcategory_id = params[:part][:partcategory_id]
		  part.status = 1
      part.is_assign = 0
      #保存
      unless part.save
        flash[:danger] = "配件批量添加失败: 第#{i}个开始失败"
        return redirect_to parts_path
      end
		   i +=1
		end
    flash[:success] = "配件批量添加成功,添加数量#{i}个"
		redirect_to parts_path
	end


  #配件信息展示页面
  def show
    @part = Part.find params[:id]
    @device = @part.device    #属于哪个设备
    @user = @device.blank? ? nil : @device.user   #设备的使用人
    @partcategorys = Partcategory.leafpartcategory     #配件分类,拿到所有分类
    @decategorys = Decategory.leafdecategory     #设备分类,拿到所有分类
    @partrecords = Partrecord.where part_id: @part.id
  end

  #配件附加到设备上
  def attachdevice
    #找到要添加配件的设备
    @device = Device.find params[:device][:device_id]
    #找到配件
    @part = Part.find params[:id]
    @part.device = @device
    @part.status = 2
    @part.assign_time = Time.now
    @part.is_assign = 1
    #配件安装记录
    @partrecord = Partrecord.new
    @partrecord.part_id = @part.id
    @partrecord.device_id = @device.id
    @partrecord.note = "安装配件"
    #以后要改成事物
    if @part.save && @partrecord.save
      flash[:success] = "配件添加成功"
      return render js: "location.reload();"#保存成功使用js刷新页面
    else
      return render js: "$('#error-infoassign').html('没有添加成功').css('display','block');"
    end
  end
  #ajax返回指定种类的配件
  def ajaxgetpart
    @parts = Part.where(partcategory_id: params[:partcategoryid], is_assign: 0)
    render json: @parts
  end
  #设备show页中的配件移除链接,调用方法
  def remove
    #找到配件
    @part = Part.find params[:id]
    #拿到设备,操作后返回
    device = @part.device
    @part.device = nil
    @part.status = 3
    @part.assign_time = Time.now
    @part.is_assign = 0

    #配件移除记录
    @partrecord = Partrecord.new
    @partrecord.part_id = @part.id
    @partrecord.device_id = device.id
    @partrecord.note = "移除配件"


    if @part.save && @partrecord.save
      flash[:success] = "配件移除成功"
      redirect_to request.referer
    else
      flash[:success] = "配件移除失败"
      redirect_to request.referer
    end

  end

  def destroy
    @part = Part.find params[:id]

    if @part.device.blank?
      @part.destroy
      flash[:success] = "删除成功"
      redirect_to parts_path
    else
      flash[:danger] = "删除失败"
      redirect_to parts_path
    end
  end
  private
    def part_params
      params.require(:part).permit(:partcategory_id, :part_name, :part_details, :receive_date)
    end
    #生成配件编码
    def getpartcode(partcategory_id)
      partcategory = Partcategory.find partcategory_id
      partcategorycode = partcategory.partcategorycode
      parts = Part.where(partcategory_id: partcategory_id)
      num = parts.count + 1
      time = Time.now
      return 'YK' + time.month.to_s + time.day.to_s + '-' + partcategorycode + '-' + num.to_s
    end
end
