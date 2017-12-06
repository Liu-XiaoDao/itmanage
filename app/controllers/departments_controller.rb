class DepartmentsController < ApplicationController
	layout 'home'

	def index
		@departments = Department.all.paginate page: params[:page], per_page: 20
	end

	def update
		@department = Department.find(params[:id])

		if @department.update(device_params)
			redirect_to departments_path
		else
			@users = User.all
			render :new
		end
	end

	def new
		@department = Department.new
		@users = User.all
	end

	def show
		#部门
		@department = Department.find(params[:id])

		#本部门及下级部门所有员工
		@departmentUsers = User.joins("INNER JOIN departments ON users.department_id = departments.id AND departments.pgcode like '#{@department.pgcode}%'").paginate page: params[:page], per_page: 20

		@higherdepartment = @department.higher
	    @lowerdepartments = @department.lowers
	    @departmentnew = Department.new

	    @users = User.all
	end

	def edit
		@department = Department.find(params[:id])
		@users = User.all
	end

	def create

		@departmentcount = Department.where(parent_id: 0).count

		@department = Department.new(device_params)
		@department.pgcode = @departmentcount + 1
		@department.parent_id = 0

		if @department.save
			redirect_to departments_path
		else
			@users = User.all
			render :new
		end
	end

	#
	def departmentusers  #返回指定部门中所有员工
		@department = Department.find(params[:id])
		@departmentusers = @department.users
		render json: @departmentusers
		# @devices = User.where(decategory_id: params[:decategoryid], is_assign: 0)
	 #    render json: @devices
	
	end

	#在部门中中添加下级部门
	def addlowerdepartment
		#查询将要添加子类的这个分类中,现在有多少子类,根据子类数量,生成自身的pgcode
		#拿到将要添加下级部门的部门
		@highdepartment = Department.find(params[:parent_id])
		#查询此部门下现有下级部门数量
		@departmentcount = Department.where(parent_id: @highdepartment.id).count
		
		#添加新部门
		@department = Department.new(device_params)
		@department.parent_id = @highdepartment.id
		#根据数量生成pgcode,因为小于9的话,加1之后还是一个数字,默认占两位的,所以要根据情况先用0填充
		if @departmentcount < 9
			@department.pgcode = @highdepartment.pgcode.to_s + "0" + (@departmentcount + 1).to_s
		else
			@department.pgcode = @highdepartment.pgcode.to_s + (@departmentcount + 1).to_s
		end
		

		if @department.save
			flash[:success] = "添加下级部门成功"
			redirect_to department_path(@highdepartment)
		else 
			flash[:failed] = "添加下级部门失败   " + @department.errors.any? ? @department.errors.full_messages[0] : ""
			redirect_to department_path(@highdepartment)
		end
	end

	def destroy
    	@department = Department.find(params[:id])
    	@department.destroy
    	redirect_to departments_path
  	end

	private 
	    def device_params
	      params.require(:department).permit(:department_name, :manager_name)
	    end
end
