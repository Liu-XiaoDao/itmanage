class DecategorysController < ApplicationController
  layout 'home'

  def index
    @decategorys = Decategory.all.paginate page: params[:page], per_page: 10
  end

  def new
    @decategory = Decategory.new
  end

  #添加分类
  def create
    @decategory = Decategory.new(decategory_params)
    if @decategory.save
      redirect_to decategorys_path
    else
      render :new
    end
  end

  #在分类中添加子分类
  def addchildcategory
    @decategory = Decategory.new(decategory_params)
    @decategory.parent_id = params[:parent_id]
    if @decategory.save
      redirect_to decategorys_path
    else
      @decategorynew = @decategory
      render :show
    end
  end

  def show
    @decategory = Decategory.find params[:id]
    @parentcategory = @decategory.mdecategory
    @childcategories = @decategory.cdecategory
    @decategorynew = Decategory.new

  end

  def update
    @decategory = Decategory.find params[:id]

    if @decategory.update(decategory_params)
        redirect_to decategorys_path
    else
        render 'edit'
    end
  end

  def edit
    @decategory = Decategory.find params[:id]
  end



  def editdecategorycode
    decategory = Decategory.find params[:id]
    decategory.decategorycode = params[:decategorycode]
    decategory.save 
  end

  def destroy
    @decategory = Decategory.find params[:id]
    @decategory.destroy
    redirect_to decategorys_path
  end

  private 
      def decategory_params
        params.require(:decategory).permit(:name,:decategorycode)
      end
end
