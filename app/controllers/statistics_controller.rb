class StatisticsController < ApplicationController
  layout 'home'

  def index
    @departments = Department.where(parent_id: 0).paginate page: params[:page], per_page: 50

    respond_to { |format|
      format.html
      format.xlsx { send_data to_xlsx(@departments).stream.string, filename: "devices.xlsx", disposition: 'attachment' }
    }
  end


  def to_xlsx(departments)
    user_model_configs = current_user.user_model_configs.where(model: "custom_statistics").first
    select_fields = user_model_configs.present? ? user_model_configs.fields : []

    fields = ["部门名称", "人数", "设备总数"] + select_fields.collect{|field| Decategory.find(field).name}

    workbook = RubyXL::Workbook.new
    worksheet = workbook[0]

    fields.each_with_index do |field, col|
      worksheet.add_cell(0, col, field)
      worksheet.sheet_data[0][col].change_font_bold(true)
      worksheet.change_column_width(col, 15)
    end

    worksheet.change_row_height(0, 18)

    departments.each_with_index do |department, row|

      worksheet.add_cell(row+1, 0, parentdepartment_name(department.id))

      departmentUsers = User.joins("INNER JOIN departments ON users.department_id = departments.id AND departments.pgcode like '#{department.pgcode}%'")
      worksheet.add_cell(row+1, 1, departmentUsers.count)

      departmentdevicecount = 0
      departmentUsers.each{ |user| departmentdevicecount = departmentdevicecount + user.statistic_devices(select_fields).count }
      worksheet.add_cell(row+1, 2, departmentdevicecount)

      select_fields.each_with_index do |field, col|
        tempdecategorydevicecount = 0
        departmentUsers.each{ |user| tempdecategorydevicecount = tempdecategorydevicecount + user.statistic_devices(field).count }
        worksheet.add_cell(row+1, col+3, tempdecategorydevicecount)
      end
      
      worksheet.change_row_height(row+1, 18)
    end
    workbook
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
