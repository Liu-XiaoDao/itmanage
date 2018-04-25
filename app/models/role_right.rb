class RoleRight < ApplicationRecord
  belongs_to :role, optional: true
  belongs_to :right, optional: true
end
