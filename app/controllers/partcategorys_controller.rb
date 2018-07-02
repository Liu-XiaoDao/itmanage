class PartcategorysController < ApplicationController

  layout 'home'
  #配件所有分类列表
  def index
    @partcategorys = Partcategory.all.paginate page: params[:page], per_page: 15
  end
  #新建配件分类页面
  def new
    @partcategory = Partcategory.new
  end
  #添加配件分类
  def create
    #在这里添加的都是顶级配件分类
    #拿到丁姐配件分类的数量
    @partcategorycount = Partcategory.where(parent_id: 0).count
    #新建配件分类
    @partcategory = Partcategory.new(partcategory_params)
    #顶级分类的parent_id为0
    @partcategory.parent_id = 0
    #根据是否小于9,决定是否添加0
    if @partcategorycount < 9
      @partcategory.pgcode = "0" + (@partcategorycount + 1).to_s
    else
      @partcategory.pgcode = @partcategorycount + 1
    end
    #保存
    if @partcategory.save
      flash[:success] = "新建配件分类成功"
      redirect_to partcategorys_path
    else
      render :new
    end
  end
  #修改配件分类
  def edit
    @partcategory = Partcategory.find params[:id]
  end
  #修改
  def update
     @partcategory = Partcategory.find params[:id]
    if @partcategory.update(partcategory_params)
        flash[:success] = "修改配件分类成功"
        redirect_to partcategorys_path
    else
        render :edit
    end
  end
  #显示一条配件分类的详情
  def show
    #要显示的分类
    @partcategory = Partcategory.find params[:id]
    #父类
    @parentcategory = @partcategory.mpartcategory
    #所有子类
    @childcategories = @partcategory.cpartcategory
    #添加新子类所用空实例
    @partcategorynew = Partcategory.new
    #查询当前类或者子类的配件(因为如果有子类那么下面就不会有配件)
    @categoryparts = Part.joins("INNER JOIN partcategories ON parts.partcategory_id = partcategories.id AND partcategories.pgcode like '#{@partcategory.pgcode}%'").paginate page: params[:page], per_page: 20
  end
  #在分类中添加子分类
  def addchildcategory
    #拿到要添加子类的分类
    @parentpartcategory = Partcategory.find(params[:parent_id])
    #查询当前分类下面的子类数量
    @partcategorycount = Partcategory.where(parent_id: @parentpartcategory.id).count
    #新建子类
    @partcategory = Partcategory.new(partcategory_params)
    #指定子类的父类
    @partcategory.parent_id = @parentpartcategory.id
    #检测是否加个0
    if @partcategorycount < 9
      @partcategory.pgcode = @parentpartcategory.pgcode.to_s + "0" + (@partcategorycount + 1).to_s
    else
      @partcategory.pgcode = @parentpartcategory.pgcode.to_s + (@partcategorycount + 1).to_s
    end
    #保存
    if @partcategory.save

      #当一个叶子配件分类添加子分类后,如果之前这个叶子配件分类有配件,那么配件会放到新子类下
      Part.where(partcategory_id: @parentpartcategory.id).each do |part|
        part.partcategory_id = @partcategory.id
        part.save
      end

      return render js: "$('#error-danger').html('添加子类成功').css('display','block');"
    else
      return render js: "$('#error-danger').html('" + "#{@partcategory.errors.full_messages[0]}" + "').css('display','block');"
    end
  end


  #修改分类代码
  def editpartcategorycode
    @partcategory = Partcategory.find params[:id]
    @partcategory.partcategorycode = params[:partcategorycode]
    @partcategory.save
  end

  def destroy
    @partcategory = Partcategory.find params[:id]

    if @partcategory.parts.blank? && @partcategory.cpartcategory.blank?
      @partcategory.destroy
      flash[:success] = "配件分类删除成功"
      redirect_to partcategorys_path
    else
      flash[:danger] = "配件分类删除失败"
      redirect_to partcategorys_path
    end

  end

  private
    def partcategory_params
      params.require(:partcategory).permit(:name,:partcategorycode)
    end
end
