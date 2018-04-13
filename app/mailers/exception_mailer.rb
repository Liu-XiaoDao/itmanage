class ExceptionMailer < ApplicationMailer

  default from: 'no-reply@abcam.com'

  def exception_nitofy
    @greeting = "Hi"

    mail to: "957419420@qq.com", subject: "测试邮件发送"
  end

  def scrap_nitofy(devices)
    @devices = devices

    emailarr = Siteinfo.first.blank? ?  ["957419420@qq.com"] : Siteinfo.first.emailrecive.split(",")
    mail to: emailarr, subject: "设备到期提醒"
  end


  def service_nitofy(services)
    @services = services

    emailarr = Siteinfo.first.blank? ?  ["957419420@qq.com"] : Siteinfo.first.emailrecive.split(",")
    mail to: emailarr, subject: "服务到期提醒"
  end

end
