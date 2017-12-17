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


  validates :username, :email, :attendance, :department_id, presence: true   #这几个变量不能为空
  validates :username, length: { in: 2..25 }, #长度6-25
                       uniqueness: { case_sensitive: false, message: "用户名已经被使用" }  #唯一性检测，不区分大小写
  validates :attendance, length: { in: 1..25 } #长度6-25
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


  def avatar_upload(file)
    root_path = "#{Rails.root}/public"
    dir_path = "/images/avatar/#{Time.now.strftime('%Y%m')}"
    final_path = root_path + dir_path
    if !File.exist?(final_path)
      FileUtils.makedirs(final_path)
    end
    file_rename = "#{Digest::MD5.hexdigest(Time.now.to_s)}#{File.extname(file.original_filename)}"
    file_path = "#{final_path}/#{file_rename}"
    File.open(file_path,'wb+') do |item| #用二进制对文件进行写入
      item.write(file.read)
    end
    self.avatar = "#{dir_path}/#{file_rename}"
    save
  end

  def delete_picture(picture_path)
    file_path = "#{Rails.root}/public/#{picture_path}"
    if File.exist?(file_path)
      File.delete(file_path)
    end
  end





end
