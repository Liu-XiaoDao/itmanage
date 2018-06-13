class Authorizationservice < ApplicationRecord
  belongs_to :authorization
  has_many :attached_files, ->{ where( attached_files: { target_class: "authorizationservices" } ) }, :foreign_key => :target_id
end
