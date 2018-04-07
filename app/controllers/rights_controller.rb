class RightsController < ApplicationController
  layout 'home'
  def index
    @rights = Right.all.paginate page: params[:page], per_page: 20
  end

  def new
    @right = Right.new
  end

  def create
    @right = Right.new(right_params)
    if @right.save
      flash[:success] = "权限添加成功"
      redirect_to rights_path
    else
      render :new
    end
  end

  def edit
    @right = Right.find(params[:id])
  end

  def show
    @right = Right.find(params[:id])
  end

  def update
    @right = Right.find(params[:id])
    if @right.update(right_params)
      flash[:success] = "权限修改成功"
      redirect_to rights_path
    else
      render :edit
    end
  end

  def destroy
    @right = Right.find(params[:id])
    @right.destroy
    flash[:success] = "权限删除成功"
    redirect_to rights_path
  end

  private
    def right_params
      params.require(:right).permit(:right_name, :right)
    end
end
