class User < ApplicationRecord

  has_many :devices
  belongs_to :department, optional: true

  validates :username, :email, :password, presence: true   #这几个变量不能为空
  validates :username, length: { in: 6..25 }, #长度6-25
                       uniqueness: { case_sensitive: false, message: "111用户名已经被使用" }  #唯一性检测，不区分大小写
  validates :nickname, length: { in: 6..25 } #长度6-25
  validates :email,    length: { maximum: 255 },  #最长为255
                       uniqueness: { case_sensitive: false, message: "11邮箱已经被使用" }  #唯一性检测，不区分大小写
  validates :password, length: { minimum: 6 },  #密码最短6位
                       allow_nil: false  #为空也不跳过
 

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
