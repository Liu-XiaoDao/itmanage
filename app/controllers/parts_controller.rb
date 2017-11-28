class PartsController < ApplicationController
  layout 'home'
  
  def index
    @parts = Part.all.paginate page: params[:page], per_page: 10
    @partcategorys = Partcategory.all
    @status = YAML.load_file("#{Rails.root}/config/status.yml")['part']
  end

    #搜索设备
  def search
    @partcategory_id = params[:part][:partcategory_id]
    @assign = params[:part][:assign]
    @status_id = params[:part][:status_id]

    if @partcategory_id.blank? && @assign.blank? && @status_id.blank?
      redirect_to parts_path
    else

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

      @parts = Part.where(searchstr).paginate page: params[:page], per_page: 10
      @partcategorys = Partcategory.all
      @status = YAML.load_file("#{Rails.root}/config/status.yml")['part']
      render "index"

    end

  end

    #添加设备试图
  def new
    @part = Part.new
    @partcategorys = Partcategory.all
  end

	#添加设备
  def create
    @part = Part.new(part_params)
    @part.part_code = getpartcode(params[:part][:partcategory_id])
    @part.status = 1
    @part.is_assign = 0
    if @part.save
      redirect_to parts_path
    else

    end
  end

  def edit
    @part = Part.find params[:id]
    @partcategorys = Partcategory.all
  end

  def update
  	@part = Part.find params[:id]
  	@part.update part_params
    if @part.save
      redirect_to parts_path
    else

    end
  end

  #批量添加界面
  def batchadd
    @part = Part.new
    @partcategorys = Partcategory.all
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
		   part.save
		   i +=1
		end

		redirect_to parts_path
	end

  #配件信息展示页面
  def show
    @part = Part.find params[:id]

    @device = @part.device    #属于哪个设备



    @user = @device.blank? ? nil : @device.user   #设备的使用人

    @partcategorys = Partcategory.all     #配件分类,拿到所有分类
    @decategorys = Decategory.all     #设备分类,拿到所有分类
    # @devicerecords = Devicerecord.where device_id: @device.id
  end


  def attachdevice
    @device = Device.find params[:device][:device_id]
    @part = Part.find params[:id]
    @part.device = @device
    @part.status = 2
    @part.assign_time = Time.now
    @part.is_assign = 1

    if @part.save
      redirect_to part_path(params[:id])
    else

    end
  end





  def ajaxgetpart
    @parts = Part.where(partcategory_id: params[:partcategoryid], is_assign: 0)
    render json: @parts
  end

  private

    def part_params
      params.require(:part).permit(:partcategory_id, :part_name, :part_details, :receive_date)
    end

    def getpartcode(partcategory_id)
      partcategory = Partcategory.find partcategory_id
      partcategorycode = partcategory.partcategorycode

      parts = Part.where(partcategory_id: partcategory_id)
      num = parts.count + 1
      time = Time.now
      return 'YK' + time.month.to_s + time.day.to_s + '-' + partcategorycode + '-' + num.to_s
    end
end
