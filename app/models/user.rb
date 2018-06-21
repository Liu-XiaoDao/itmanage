class User < ApplicationRecord

  has_many :devices
  belongs_to :department, optional: true

  #耗材领取记录
  has_many :consumablerecords
  has_many :consumables, through: :consumablerecords

  #设备使用记录(曾经和现在用过哪些设备)
  has_many :devicerecords, dependent: :destroy
  has_many :oncedevices, through: :devicerecords

  #授权分配记录
  has_many :authorization_user_devices
  has_many :authorizations, through: :authorization_user_devices

  has_many :user_model_configs

  #用户拥有权限
  has_many :user_roles
  has_many :roles, through: :user_roles
  has_many :rights, through: :roles

  cattr_accessor :current_user

  validates :username, :email, :department_id, presence: true   #这几个变量不能为空
  validates :username, length: { in: 2..25 }, #长度6-25
                       uniqueness: { case_sensitive: false, message: "用户名已经被使用" }  #唯一性检测，不区分大小写
  validates :email,    length: { in: 6..55 },  #最长为255
                       uniqueness: { case_sensitive: false, message: "邮箱已经被使用" }  #唯一性检测，不区分大小写
  # validates :password, length: { minimum: 6 },  #密码最短6位
  #                      allow_nil: false  #为空也不跳过


   #ldap登录
  def self.from_omniauth(auth)
    user = User.where(email: auth.info.email).first
  end

  #密码对别
  def compare(password)
      self.password == password ? true : false
  end



  def delete_picture(picture_path)
    file_path = "#{Rails.root}/public/#{picture_path}"
    if File.exist?(file_path)
      File.delete(file_path)
    end
  end
  #导出数据时显示部门名称使用
  def department_name
    department.department_name
  end



  def statistic_devices(fields)
    # fields = current_user.user_model_configs.where(model: "custom_statistics").first.present? ? current_user.user_model_configs.where(model: "custom_statistics").first.fields : []
    fields.present? ? devices.where(decategory_id: fields) : devices

  end

  def self.to_xlsx(records)
    export_fields = ["id", "username", "email", "department_name", "position"]
    SpreadsheetService.new.generate(export_fields, records)
  end



end
