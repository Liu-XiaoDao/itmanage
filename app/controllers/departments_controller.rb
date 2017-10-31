class DepartmentsController < ApplicationController
	layout 'home'
	def index
		@departments = Department.all.paginate page: params[:page], per_page: 10
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

	def edit
		@department = Department.find(params[:id])
		@users = User.all
	end

	def create
		@department = Department.new(device_params)
		if @department.save
			redirect_to departments_path
		else
			@users = User.all
			render :new
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
