class StatisticsController < ApplicationController
  layout 'home'

  def index
    @departments = Department.all

    respond_to { |format|
      format.html
      format.xlsx { send_data to_xlsx(@departments).stream.string, filename: "statistics.xlsx", disposition: 'attachment' }
    }
  end


  def to_xlsx(departments)
    user_model_configs = current_user.user_model_configs.where(model: "custom_statistics").first
    select_fields = user_model_configs.present? ? user_model_configs.fields : []

    fields = ["部门名称", "人数", "电脑", "比例", "电脑(员工借用)", "电脑(接设备)"]
    if select_fields.present?
      fields = fields + ["设备总数",] + select_fields.collect{|field| Decategory.find(field).name}
    end

    workbook = RubyXL::Workbook.new
    worksheet0 = workbook[0]
    worksheet1 = workbook.add_worksheet('Sheet2')

    create_sheet(select_fields, fields, departments.where(parent_id: 0), worksheet0)
    create_sheet(select_fields, fields, departments.where.not(parent_id: 0), worksheet1)

    workbook
  end

  def create_sheet(select_fields, fields, departments, worksheet)
    fields.each_with_index do |field, col|
      worksheet.add_cell(0, col, field)
      worksheet.sheet_data[0][col].change_font_bold(true)
      worksheet.change_column_width(col, 15)
    end

    worksheet.change_row_height(0, 18)

    departments.each_with_index do |department, row|
      worksheet.add_cell(row+1, 0, department.department_name)

      departmentUsers = User.joins("INNER JOIN departments ON users.department_id = departments.id where users.is_quit = 0 AND departments.pgcode like '#{department.pgcode}%'")
      worksheet.add_cell(row+1, 1, departmentUsers.count)

      departstaffuse = 0
      departmentUsers.each{ |user| departstaffuse = departstaffuse + user.statistic_devices([1,2]).where(status: [2]).count }
      worksheet.add_cell(row+1, 2, departstaffuse)

      #比例
      worksheet.add_cell(row+1, 3, "#{(departstaffuse.to_f/departmentUsers.count.to_f*100).round(1)}%")

      #部门员工借用的电脑
      brodepartmentdevicecount = 0
      departmentUsers.each{ |user| brodepartmentdevicecount = brodepartmentdevicecount + user.statistic_devices([1,2]).where(status: 3).count }
      worksheet.add_cell(row+1, 4, brodepartmentdevicecount)

      #部门接设备的电脑
      condepartmentdevicecount = 0
      departmentUsers.each{ |user| condepartmentdevicecount = condepartmentdevicecount + user.statistic_devices([1,2]).where(status: 4).count }
      worksheet.add_cell(row+1, 5, condepartmentdevicecount)

      if select_fields.present?
        departmentdevicecount = 0
        departmentUsers.each{ |user| departmentdevicecount = departmentdevicecount + user.statistic_devices(select_fields).count }
        worksheet.add_cell(row+1, 6, departmentdevicecount)

        select_fields.each_with_index do |field, col|
          tempdecategorydevicecount = 0
          departmentUsers.each{ |user| tempdecategorydevicecount = tempdecategorydevicecount + user.statistic_devices(field).count }
          worksheet.add_cell(row+1, col+7, tempdecategorydevicecount)
        end
      end



      worksheet.change_row_height(row+1, 18)
    end

  end



  def show
    #拿到要显示的部门
    @department = Department.find(params[:id])
    #本部门及下级部门所有员工
    @departmentUsers = User.joins("INNER JOIN departments ON users.department_id = departments.id where users.is_quit = 0 AND departments.pgcode like '#{@department.pgcode}%'")
  end
end
