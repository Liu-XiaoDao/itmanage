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

  #上下属关系
  belongs_to :header, class_name:  'User', foreign_key: 'leader_id', optional: true  #直接领导
  has_many :understrappers, class_name: 'User', foreign_key: 'leader_id'  #直接下属


  cattr_accessor :current_user

  validates :username, :department_id, presence: true   #这几个变量不能为空
  validates :username, length: { in: 2..25 }, #长度6-25
                       uniqueness: { case_sensitive: false, message: "用户名已经被使用" }  #唯一性检测，不区分大小写

   #ldap登录
  def self.from_omniauth(auth)
    user = User.where(email: auth.info.email).first
  end

  #密码对别
  def compare(password)
      self.password == password ? true : false
  end

  #导出数据时显示部门名称使用
  def department_name
    department.try :department_name
  end

  def department_name=(department_name)
    department = Department.find_by_department_name(department_name)
    if department.present?
      self.department_id = department.id
    end
  end
  #直属上级领导姓名
  def header_name
    header.present? ? header.username : "无"
  end

  def statistic_devices(fields)
    # fields = current_user.user_model_configs.where(model: "custom_statistics").first.present? ? current_user.user_model_configs.where(model: "custom_statistics").first.fields : []
    fields.present? ? devices.where(decategory_id: fields) : devices

  end

  def self.to_xlsx(records)
    export_fields = ["id", "username", "department_name", "position"]
    SpreadsheetService.new.generate(export_fields, records)
  end

  def self.import_fields
    ["username", "department_name", "position"]
  end

  def self.import_preview(file)
    update_record = []
    create_record = []

    spreadsheet = SpreadsheetService.new.parse(file)
    headers = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[headers, spreadsheet.row(i).map(&:to_s)].transpose]
      user = find_by_username(row["username"])
      if user
        user.attributes = row.to_hash.slice(*import_fields)
        update_record << user if user.changed?
      else
        user = new
        user.attributes = row.to_hash.slice(*import_fields)
        create_record << user
      end
    end

    {update_record: update_record, create_record: create_record}
  end

end
