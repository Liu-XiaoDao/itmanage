class ExceptionMailer < ApplicationMailer
  
  default from: 'liu_xiaodao@163.com'

  def exception_nitofy
    @greeting = "Hi"

    mail to: "957419420@qq.com", subject: "测试邮件发送"
  end
end
