class DecategorysController < ApplicationController
  layout 'home'

  def index
    @decategorys = Decategory.all.paginate page: params[:page], per_page: 10
    # @decategorys = Decategory.all
    # @decategorys = GetTree(@decategorys,0,0,@tree = [],"|----")
    # @decategorys = @tree
  end

  def new
    @decategory = Decategory.new
  end

  #添加分类
  def create
  	@decategorycount = Decategory.where(parent_id: 0).count

    @decategory = Decategory.new(decategory_params)
    @decategory.parent_id = 0

    if @decategorycount < 9
      @decategory.pgcode = "0" + (@decategorycount + 1).to_s
    else
      @decategory.pgcode = @decategorycount + 1
    end

    if @decategory.save
      redirect_to decategorys_path
    else
      render :new
    end
  end

  #在分类中添加子分类
  def addchildcategory
    @parentdecategory = Decategory.find(params[:parent_id])
    @decategorycount = Decategory.where(parent_id: @parentdecategory.id).count
    @decategory = Decategory.new(decategory_params)
    @decategory.parent_id = @parentdecategory.id

    if @decategorycount < 9
      @decategory.pgcode = @parentdecategory.pgcode.to_s + "0" + (@decategorycount + 1).to_s
    else
      @decategory.pgcode = @parentdecategory.pgcode.to_s + (@decategorycount + 1).to_s
    end

    if @decategory.save
      redirect_to decategorys_path
    else
      return render js: "$('#error-info').html('" + "#{@decategory.errors.full_messages[0]}" + "').css('display','block');"
    end
  end

  def show
    @decategory = Decategory.find params[:id]
    @parentcategory = @decategory.mdecategory
    @childcategories = @decategory.cdecategory
    @decategorynew = Decategory.new

    @decategorydevices = Device.where(decategory_id: params[:id]).paginate page: params[:page], per_page: 10
    @categoryparts = Device.joins("INNER JOIN decategories ON devices.decategory_id = decategories.id AND decategories.pgcode like '#{@decategory.pgcode}%'").paginate page: params[:page], per_page: 20
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
