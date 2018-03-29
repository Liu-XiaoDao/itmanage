class UserModelConfig < ApplicationRecord
  belongs_to :user, optional: true


  def fields
    read_attribute(:fields_text).present? ? read_attribute(:fields_text).split(',').reject(&:empty?) : []
  end
end
