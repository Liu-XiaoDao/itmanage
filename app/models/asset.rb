class Asset < ApplicationRecord
	validates :asset_code, presence: true   #这几个变量不能为空
  	validates :asset_code, :asset_name, :service_sn, :model, :managed_by, :asset_details, :belong_to,   length: { in: 6..25 }, #长度6-25
                       																					uniqueness: { case_sensitive: false }  #唯一性检测，不区分大小写
  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    
  end

  def self.open_spreadsheet(file)
    File.extname(file.original_filename)
  end
end
