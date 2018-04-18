class ExceptionMailer < ApplicationMailer

  default from: Rails.env == "production" ? "设备管理系统 <no-reply@abcam.com>" : "小刀 <liu_xiaodao@163.com>"

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
