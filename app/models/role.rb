class Role < ApplicationRecord
  has_many :role_rights
  has_many :rights, through: :role_rights

  has_many :user_roles
  has_many :users, through: :user_roles
end
