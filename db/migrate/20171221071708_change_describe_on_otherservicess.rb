class ChangeDescribeOnOtherservicess < ActiveRecord::Migration[5.1]
  def change
  	change_table :otherservices do |t|  
	  t.change :describe, :text
	end
  end
end
