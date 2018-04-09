class Right < ApplicationRecord
  has_many :role_rights
  has_many :roles, through: :role_rights
end
