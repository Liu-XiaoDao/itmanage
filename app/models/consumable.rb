class Consumable < ApplicationRecord
  has_many :consumablerecords
  has_many :users, through: :consumablerecords
end
