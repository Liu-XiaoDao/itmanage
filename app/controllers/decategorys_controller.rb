class DecategorysController < ApplicationController
  layout 'home'

  #设备分类index
  def index
    @decategorys = Decategory.all.paginate page: params[:page], per_page: 10
  end

  #新增分类页面
  def new
    @decategory = Decategory.new
  end

  #添加分类
  def create
    #拿到当前顶级分类数量
    @decategorycount = Decategory.where(parent_id: 0).count
    #增加分类
    @decategory = Decategory.new(decategory_params)
    @decategory.parent_id = 0  #在这类创假的都是顶级分类,所以为0
    #根据当前数量决定是否添加0
    if @decategorycount < 9
      @decategory.pgcode = "0" + (@decategorycount + 1).to_s
    else
      @decategory.pgcode = @decategorycount + 1
    end
    #保存
    if @decategory.save
      flash[:success] = "添加分类成功"
      redirect_to decategorys_path
    else
      render :new
    end
  end

  #在分类中添加子分类
  def addchildcategory
    #拿到要添加子类的父类
    @parentdecategory = Decategory.find(params[:parent_id])
    #拿到父类下子类的数量
    @decategorycount = Decategory.where(parent_id: @parentdecategory.id).count
    #创建新类
    @decategory = Decategory.new(decategory_params)
    #指定父类
    @decategory.parent_id = @parentdecategory.id
    #根据当前数量决定是否添加0
    if @decategorycount < 9
      @decategory.pgcode = @parentdecategory.pgcode.to_s + "0" + (@decategorycount + 1).to_s
    else
      @decategory.pgcode = @parentdecategory.pgcode.to_s + (@decategorycount + 1).to_s
    end
    #保存
    if @decategory.save

      #当一个叶子设备分类添加子分类后,如果之前这个叶子设备分类有设备,那么设备会放到新子类下
      Device.where(decategory_id: @parentdecategory.id).each do |device|
        device.decategory_id = @decategory.id
        device.save
      end

      return render js: "$('#error-info').html('添加子类成功').css('display','block');"
    else
      return render js: "$('#error-info').html('" + "#{@decategory.errors.full_messages[0]}" + "').css('display','block');"
    end
  end

  #分类详情
  def show
    #当前类
    @decategory = Decategory.find params[:id]
    #当前类的父类
    @parentcategory = @decategory.mdecategory
    #当前类的所有子类
    @childcategories = @decategory.cdecategory
    #添加子类所需空实例
    @decategorynew = Decategory.new

    # @decategorydevices = Device.where(decategory_id: params[:id]).paginate page: params[:page], per_page: 10
    #当前类下的所有设备使用分类代码查找
    @decategorydevices = Device.joins("INNER JOIN decategories ON devices.decategory_id = decategories.id AND decategories.pgcode like '#{@decategory.pgcode}%'").paginate page: params[:page], per_page: 15
  end

  #修改分类
  def update
    #拿到要修改的分类
    @decategory = Decategory.find params[:id]
    #直接更新
    if @decategory.update(decategory_params)
        flash[:success] = "修改分类成功"
        redirect_to decategorys_path
    else
        render 'edit'
    end
  end

  #修改分类页面
  def edit
    @decategory = Decategory.find params[:id]
  end


  #ajax修改设备编号前缀
  def editdecategorycode
    #拿到分类
    decategory = Decategory.find params[:id]
    #设置编码
    decategory.decategorycode = params[:decategorycode]
    #保存
    decategory.save
  end

  def destroy
    @decategory = Decategory.find params[:id]

    if @decategory.cdecategory.blank? && @decategory.devices.blank?
      @decategory.destroy
      flash[:success] = "设备分类删除成功"
      redirect_to decategorys_path
    else
      flash[:danger] = "设备分类有子类或者分类下有设备,不允许删除"
      redirect_to decategorys_path
    end

  end

  private
      def decategory_params
        params.require(:decategory).permit(:name,:decategorycode)
      end
end
