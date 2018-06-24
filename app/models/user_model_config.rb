class UserModelConfig < ApplicationRecord
  belongs_to :user, optional: true


  def fields
    read_attribute(:fields_text).present? ? read_attribute(:fields_text).split(',').reject(&:empty?) : []
  end

  def department_nil_fields
    fields.present? ? fields : Department.all.pluck(:id)
  end
end
