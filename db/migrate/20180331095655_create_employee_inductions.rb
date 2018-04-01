class CreateEmployeeInductions < ActiveRecord::Migration[5.1]
  def change
    create_table :employee_inductions do |t|
      t.string :employee_name
      t.date   :induction_date
      t.references :department
      t.integer  :leader
      t.text :fields_text
      t.timestamps
    end
  end
end
