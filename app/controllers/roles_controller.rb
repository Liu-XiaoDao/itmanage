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
    @rights = Right.all
    @my_rights = @role.rights
  end

  def show
    @role = Role.find(params[:id])
    @rights = Right.all
    @my_rights = @role.rights
  end

  def update
    @role = Role.find(params[:id])

    @my_rights = @role.rights
    @params_rights = Right.where(id: params[:rights])

    @delete_rights = @my_rights - @params_rights
    @delete_rights.each do |delete_right|
      RoleRight.where(role_id: @role.id, right_id: delete_right.id).first.destroy
    end

    @add_rights = @params_rights - @my_rights
    @add_rights.each do |add_right|
      roleright = RoleRight.create(role_id: @role.id, right_id: add_right.id)
    end

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
