class ConsumablesController < ApplicationController

  layout 'home'

  def index
    @consumables = Consumable.all.paginate page: params[:page], per_page: 10
    @consumableamount = 0
    @consumables.each { |consumable| @consumableamount += consumable.amount }
  end

  def new
    @consumable = Consumable.new
  end

  def edit
    @consumable = Consumable.find(params[:id])
  end

  def update
    #修改一个耗材
    @consumable = Consumable.find(params[:id])
    
    @consumable.name = params[:consumable][:name]
    @consumable.unit = params[:consumable][:unit]
    @consumable.location = params[:consumable][:location]

    if @consumable.save
      flash[:success] = "修改成功"
      redirect_to consumables_path
    else
      render :edit
    end
  end

  def show
    @consumablerecords = Consumablerecord.where(consumable_id: params[:id]).paginate page: params[:page], per_page: 20
  end

  def create
    #新增一个耗材
    @consumable = Consumable.new(consumable_params)
    #因为是新增的所以已用为0
    @consumable.used_amount = 0
    #总量就是现在数量
    @consumable.amount = @consumable.surplus_amount

    if @consumable.save
      flash[:success] = "增加成功"
      redirect_to consumables_path
    else
      render :new
    end
  end

  #增加库存试图
  def addstocknew
    @consumable = Consumable.find(params[:id])
    render layout: false
  end

  #增加库存
  def addstock
    @consumable = Consumable.find(params[:id])
    @consumable.amount +=  params[:consumable][:number].to_i
    @consumable.surplus_amount += params[:consumable][:number].to_i

    if @consumable.save
      flash[:success] = "库存增加成功"
      redirect_to consumables_path
    else
      flash[:danger] = "库存增加失败"
      redirect_to consumables_path
    end
  end


  def destroy
    @consumable = Consumable.find(params[:id])

    if @consumable.consumablerecords.blank?
      @consumable.destroy
      flash[:success] = "耗材删除成功"
      redirect_to consumables_path
    else
      flash[:danger] = "耗材删除失败"
      redirect_to consumables_path
    end 
  end

  def records
    @consumablerecords = Consumablerecord.all.paginate page: params[:page], per_page: 10
  end



  private
    def consumable_params
      params.require(:consumable).permit(:name, :unit, :surplus_amount, :location)
    end


end
