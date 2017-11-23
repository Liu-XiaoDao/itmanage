class ConsumablesController < ApplicationController

  layout 'home'

  def index
    @consumables = Consumable.all.paginate page: params[:page], per_page: 10
    @consumableamount = 0
    @consumables.each { |consumable| @consumableamount += consumable.amount }

    # render plain: @consumableamount
  end

  def new
    @consumable = Consumable.new
  end

  def edit
  end

  def update
  end

  def show
  end

  def create
    #新增一个耗材
    @consumable = Consumable.new(consumable_params)
    #因为是新增的所以已用为0
    @consumable.used_amount = 0
    #总量就是现在数量
    @consumable.amount = @consumable.surplus_amount

    if @consumable.save
      redirect_to consumables_path
    else
      render :new
    end
  end


  def destroy
    @consumable = Consumable.find(params[:id])
    @consumable.destroy

    redirect_to consumables_path
  end



  private
    def consumable_params
      params.require(:consumable).permit(:name, :unit, :surplus_amount, :location)
    end


end
