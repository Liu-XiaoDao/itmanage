# Preview all emails at http://localhost:3000/rails/mailers/exception_mailer
class ExceptionMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/exception_mailer/exception_nitofy
  def exception_nitofy
    ExceptionMailer.exception_nitofy
  end

end
