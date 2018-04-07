class RolesController < ApplicationController
  layout 'home'
  def index
    @roles = Role.all.paginate page: params[:page], per_page: 20
  end

  def new
    @role = Role.new
  end

  def create
    @role = Role.new(role_params)
    if @role.save
      flash[:success] = "角色添加成功"
      redirect_to roles_path
    else
      render :new
    end
  end

  def edit
    @role = Role.find(params[:id])
  end

  def show
    @role = Role.find(params[:id])
  end

  def update
    @role = Role.find(params[:id])
    if @role.update(role_params)
      flash[:success] = "角色修改成功"
      redirect_to roles_path
    else
      render :edit
    end
  end

  def destroy
    @role = Role.find(params[:id])
    @role.destroy
    flash[:success] = "角色删除成功"
    redirect_to roles_path
  end

  private
    def role_params
      params.require(:role).permit(:role_name)
    end
end
