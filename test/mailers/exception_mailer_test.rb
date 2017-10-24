require 'test_helper'

class ExceptionMailerTest < ActionMailer::TestCase
  test "exception_nitofy" do
    mail = ExceptionMailer.exception_nitofy
    assert_equal "Exception nitofy", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
