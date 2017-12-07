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
    @partcategorycount = Partcategory.where(parent_id: 0).count

    @partcategory = Partcategory.new(partcategory_params)

    @partcategory.parent_id = 0

    if @partcategorycount < 9
      @partcategory.pgcode = "0" + (@partcategorycount + 1).to_s
    else
      @partcategory.pgcode = @partcategorycount + 1
    end

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

    # @categoryparts = Part.where(partcategory_id: params[:id]).paginate page: params[:page], per_page: 10
    @categoryparts = Part.joins("INNER JOIN partcategories ON parts.partcategory_id = partcategories.id AND partcategories.pgcode like '#{@partcategory.pgcode}%'").paginate page: params[:page], per_page: 20

  end

  #在分类中添加子分类
  def addchildcategory
    @parentpartcategory = Partcategory.find(params[:parent_id])
    @partcategorycount = Partcategory.where(parent_id: @parentpartcategory.id).count

    @partcategory = Partcategory.new(partcategory_params)
    @partcategory.parent_id = @parentpartcategory.id

    if @partcategorycount < 9
      @partcategory.pgcode = @parentpartcategory.pgcode.to_s + "0" + (@partcategorycount + 1).to_s
    else
      @partcategory.pgcode = @parentpartcategory.pgcode.to_s + (@partcategorycount + 1).to_s
    end

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
    @partcategory = Partcategory.find params[:id]
    @partcategory.destroy
    redirect_to partcategorys_path
  end

  private 
    def partcategory_params
      params.require(:partcategory).permit(:name,:partcategorycode)
    end
end
