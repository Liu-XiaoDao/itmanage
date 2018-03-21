class SpreadsheetService
  def parse(file)
    case File.extname(file.original_filename)
    when ".csv" then Roo::CSV.new(file.path)
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def generate(fields, records)
    workbook = RubyXL::Workbook.new
    worksheet = workbook[0]

    fields.each_with_index do |field, col|
      worksheet.add_cell(0, col, field)
      worksheet.sheet_data[0][col].change_font_bold(true)
      worksheet.change_column_width(col, 15)
    end

    worksheet.change_row_height(0, 18)

    records.each_with_index do |record, row|
      fields.each_with_index do |field, col|
        worksheet.add_cell(row+1, col, record.send(field).to_s)
      end
      worksheet.change_row_height(row+1, 18)
    end

    workbook
  end
end
