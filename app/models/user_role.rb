class UserRole < ApplicationRecord
  belongs_to :role, optional: true
  belongs_to :user, optional: true
end
