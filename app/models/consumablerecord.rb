class Consumablerecord < ApplicationRecord
  belongs_to :user
  belongs_to :consumable
end
