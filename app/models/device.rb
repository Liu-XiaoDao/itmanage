class Device < ApplicationRecord
  belongs_to :user, optional: true   #设备会分配给用户使用(借用,办公分配)

  has_many :parts     #一个设备由多个配件,如内存.硬盘

  has_many :deviceservices #一个设备会有多条维保记录


  #设备曾经有过哪些使用者
  has_many :devicerecords, dependent: :destroy
  has_many :onceusers, through: :devicerecords

  #授权分配记录
  has_many :authorization_user_devices
  has_many :authorizations, through: :authorization_user_devices

  validates :asset_name,  :decategory_id, :release_date,  presence: true  #这几个不能为空
  validates :asset_name,  length: { in: 2..25 } #设备名长度6-25

  validates :asset_code,  uniqueness: { case_sensitive: false }#设备编码要唯一


  def device_category_name
    Decategory.find_by_id(self.decategory_id).try(:name)
  end

  def self.to_xlsx(records)
    export_fields = ["id", "asset_code", "asset_name", "service_sn", "asset_details", "status", "user_id", "location"]
    SpreadsheetService.new.generate(export_fields, records)
  end
end
