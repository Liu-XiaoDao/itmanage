class AttachedFile < ApplicationRecord



  #保存图片
  def upload_file(file,obj)
    self.filepath = save_file(file)
    self.target_class = obj.class.table_name
    self.target_id = obj.id
    self.original = file.original_filename
  end

  def save_file(file)
    root_path = "#{Rails.root}/public"
    dir_path = "/images/service/#{Time.now.strftime('%Y%m')}"
    final_path = root_path + dir_path
    if !File.exist?(final_path)
      FileUtils.makedirs(final_path)
    end
    file_rename = "#{Digest::MD5.hexdigest(Time.now.to_s)}#{File.extname(file.original_filename)}"
    file_path = "#{final_path}/#{file_rename}"
    File.open(file_path,'wb+') do |item| #用二进制对文件进行写入
      item.write(file.read)
    end
    "#{dir_path}/#{file_rename}"
  end

end
