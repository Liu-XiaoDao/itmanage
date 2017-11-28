class ChangeParamsTextOnLogs < ActiveRecord::Migration[5.1]
  def change
  	change_table :logs do |t|  
	  t.change :params, :text
	end
  end
end
