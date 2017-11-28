class PartcategorysController < ApplicationController

  layout 'home'

  def index
  	@partcategorys = Partcategory.all.paginate page: params[:page], per_page: 10
  end

  def new
  	@partcategory = Partcategory.new
  end

  #添加分类
  def create
    @partcategory = Partcategory.new(partcategory_params)
    if @partcategory.save
      redirect_to partcategorys_path
    else
      render :new
    end
  end

  def edit
    @partcategory = Partcategory.find params[:id]
  end


  def update
     @partcategory = Partcategory.find params[:id]

    if @partcategory.update(partcategory_params)
        redirect_to partcategorys_path
    else
        render 'edit'
    end
  end


  def show
    @partcategory = Partcategory.find params[:id]
    @parentcategory = @partcategory.mpartcategory
    @childcategories = @partcategory.cpartcategory
    @partcategorynew = Partcategory.new
  end

  #在分类中添加子分类
  def addchildcategory
    @partcategory = Partcategory.new(partcategory_params)
    @partcategory.parent_id = params[:parent_id]
    if @partcategory.save
      redirect_to partcategorys_path
    else
      return render js: "$('#error-info').html('" + "#{@partcategory.errors.full_messages[0]}" + "').css('display','block');"
    end
  end

  #修改分类代码
  def editpartcategorycode
    @partcategory = Partcategory.find params[:id]
    @partcategory.partcategorycode = params[:partcategorycode]
    @partcategory.save 
  end


  def destroy
    @partcategory = Partcategory.new(partcategory_params)
    @partcategory.destroy
    redirect_to partcategorys_path
  end


  private 
    def partcategory_params
      params.require(:partcategory).permit(:name,:partcategorycode)
    end



end
