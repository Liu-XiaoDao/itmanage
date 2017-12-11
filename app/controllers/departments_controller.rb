class DepartmentsController < ApplicationController
	layout 'home'
	#部门列表页,显示所有部门
	def index
		@departments = Department.all.paginate page: params[:page], per_page: 20
	end

	#新建部门视图
	def new
		@department = Department.new
		@users = User.all
	end

	#新建部门
	def create
		#查询顶级部门的数量
		@departmentcount = Department.where(parent_id: 0).count
		#新建部门
		@department = Department.new(device_params)
		#在这里创建的是顶级部门,所以parent = 0
		@department.parent_id = 0
		#根据是否大于或小于9,决定是否加0
		if @departmentcount < 9
			@department.pgcode = "0" + (@departmentcount + 1).to_s
		else
			@department.pgcode = @departmentcount + 1
		end
		#保存
		if @department.save
			flash[:success] = "添加部门成功"
			redirect_to departments_path
		else
			#因为新建页面有一个所有员工下拉列表,所有这里也要加上
			@users = User.all
			render :new
		end
	end

	#部门详情列表
	def show
		#拿到要显示的部门
		@department = Department.find(params[:id])
		#本部门及下级部门所有员工
		@departmentUsers = User.joins("INNER JOIN departments ON users.department_id = departments.id AND departments.pgcode like '#{@department.pgcode}%'").paginate page: params[:page], per_page: 20
		#有一个上级部门(顶级部门没有)
		@higherdepartment = @department.higher
		#可能会有很多下级部门
	    @lowerdepartments = @department.lowers
	    #添加下级部门使用的空对象
	    @departmentnew = Department.new
	    #添加下级部门的时候的下拉框中显示所有员工
	    @users = User.all
	end
	#修改部门
	def edit
		@department = Department.find(params[:id])
		@users = User.all
	end

	#更新
	def update
		#拿到部门
		@department = Department.find(params[:id])
		#更新
		if @department.update(device_params)
			flash[:success] = "修改部门成功"
			redirect_to departments_path
		else
			@users = User.all
			render :edit
		end
	end


	#返回指定部门中所有员工
	def departmentusers  
		@department = Department.find(params[:id])
		@departmentusers = @department.users #这种写法可能也要改
		render json: @departmentusers
	end
	
	#在部门中添加下级部门
	def addlowerdepartment
		#查询将要添加子类的这个分类中,现在有多少子类,根据子类数量,生成自身的pgcode
		#拿到将要添加下级部门的部门
		@highdepartment = Department.find(params[:parent_id])
		#查询此部门下现有下级部门数量
		@departmentcount = Department.where(parent_id: @highdepartment.id).count
		
		#添加新部门
		@department = Department.new(device_params)
		#要添加的部门的上级部门id
		@department.parent_id = @highdepartment.id
		#根据数量生成pgcode,因为小于9的话,加1之后还是一个数字,默认占两位的,所以要根据情况先用0填充
		if @departmentcount < 9
			@department.pgcode = @highdepartment.pgcode.to_s + "0" + (@departmentcount + 1).to_s
		else
			@department.pgcode = @highdepartment.pgcode.to_s + (@departmentcount + 1).to_s
		end
		#保存
		if @department.save
			flash[:success] = "添加下级部门成功"
			redirect_to department_path(@highdepartment)
		else 
			flash[:danger] = "添加下级部门失败   " + (@department.errors.any? ? @department.errors.full_messages[0] : "")
			redirect_to department_path(@highdepartment)
		end
	end

	# def lowerdepartments
	# 	lowerdepartments = Department.where(parent_id: params[:parent_id])
	# 	result = {'status':0,'lowerdepartments':lowerdepartments}
	# 	if lowerdepartments.blank?
	# 		result = {'status':1,'msg':'当前部门没有下级部门'}
	# 	end
	# 	render json: result
	# end

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
