class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :spins, through: :taggings
end
