class ExceptionMailer < ApplicationMailer
  
  default from: 'liu_xiaodao@163.com'

  def exception_nitofy
    @greeting = "Hi"

    mail to: "957419420@qq.com", subject: "测试邮件发送"
  end

  def scrap_nitofy(devices)
    @devices = devices

    emailarr = Siteinfo.first.blank? ?  ["957419420@qq.com"] : Siteinfo.first.emailrecive.split(",")

    emailarr.each{|email| mail to: email, subject: "设备到期提醒" }

  end

end
