class Otherservice < ApplicationRecord
  has_many :oslengthens

  has_many :attached_files, ->{ where( attached_files: { target_class: "otherservices" } ) }, :foreign_key => :target_id
end
