class StatisticsController < ApplicationController
  layout 'home'

  def index
    @departments = Department.where(parent_id: 0).paginate page: params[:page], per_page: 20
  end

  def show
    #拿到要显示的部门
    @department = Department.find(params[:id])
    #本部门及下级部门所有员工
    @departmentUsers = User.joins("INNER JOIN departments ON users.department_id = departments.id AND departments.pgcode like '#{@department.pgcode}%'")
    #可能会有很多下级部门
    @lowerdepartments = @department.lowers
    #添加下级部门的时候的下拉框中显示所有员工
    @users = User.all
  end
end
