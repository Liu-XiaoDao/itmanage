class AddRemindtimeCloseremindToOtherservices < ActiveRecord::Migration[5.1]
  def change
    add_column :otherservices, :remindtime, :datetime    #提醒时间,设置一个提醒时间,到达这个时间之后开始发邮件,一般提前两个月提醒
    add_column :otherservices, :closeremind, :integer, default: 0     #是否提醒,默认提醒,当不需要提醒,把这个字段设置为1
  end
end
