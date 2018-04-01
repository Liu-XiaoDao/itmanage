class EmployeeInductionsController < ApplicationController
  layout 'home'
  def index
    @employeeinductions = EmployeeInduction.order(id: :desc).paginate page: params[:page], per_page: 50
  end

  def new
    @employeeinduction = EmployeeInduction.new
  end

  #入职流程
	def create
		#
		@employeeinduction = EmployeeInduction.new(induction_params)
		#保存
		if @employeeinduction.save
			flash[:success] = "添加入职流程成功"
			redirect_to employee_inductions_path
		else
			@employeeinduction = EmployeeInduction.new
			render :new
		end
	end

  def edit
    @employeeinduction = EmployeeInduction.find(params[:id])
  end

  #入职流程
  def update
    #
    @employeeinduction = EmployeeInduction.find(params[:id])
    #保存
    if @employeeinduction.update(induction_params)
      flash[:success] = "修改入职流程成功"
      redirect_to employee_inductions_path
    else
      render :edit
    end
  end

  private
    def induction_params
      params.require(:employee_induction).permit(:employee_name,:department_id, :leader, :induction_date)
    end
end
