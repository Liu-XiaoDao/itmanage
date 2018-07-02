class WelcomeController < ApplicationController

  skip_before_action :check_signed_in

  def index
    user = '111'

    @fouryear = Time.now + 4.years
    @fouryear = @fouryear.strftime("%Y-%m-%d %H:%M:%S")

    # if user.match(/1/i)
    #   render plain: 'true'
    # else
    #   puts 'false'
    # end

    # render plain: request.params.to_s + "---" + request.url.to_s + "---" + request.path.to_s




    if params[:file]
      FileUtils.mkdir("#{Rails.root}/public/upload") unless File.exist?("#{Rails.root}/public/upload")
      filename = params[:file]

      File.open("#{Rails.root}/public/upload/#{filename.original_filename}", "wb") do |f|
          f.write(filename.read)
      end
    puts "*********************************************************"
    puts filename
    render plain: "#{Rails.root}/public/upload/#{filename.original_filename}"
    else

    end
#    ExceptionMailer.exception_nitofy.deliver_now!
  #   SELECT distinct a.id from departments as a,departments as b where a.id = b.parent_id
  #   SELECT a.* FROM departments as a INNER JOIN departments as b ON a.id = b.parent_id
  @decategorydevices = Department.joins("INNER JOIN departments as b ON departments.id = b.parent_id ").select('id').distinct

  render json: Department.where.not(id: @decategorydevices.collect{|decategorydevice| decategorydevice.id }).select('id,department_name').order('pgcode').collect{|department| parentdepartment_name department.id }





  end



   # protected
    # def uploadfile(file)
    #   if !file.original_filename.empty?
    #     @filename = file.original_filename
    #     #设置目录路径，如果目录不存在，生成新目录
    #     FileUtils.mkdir("#{Rails.root}/public/upload") unless File.exist?("#{Rails.root}/public/upload")
    #     #写入文件
    #     ##wb 表示通过二进制方式写，可以保证文件不损坏
    #     File.open("#{Rails.root}/public/upload/#{@filename}", "wb") do |f|
    #       f.write(file.read)
    #     end
    #     return @filename
    #   end
    # end
end
