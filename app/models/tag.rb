###
# Tag Class
# Includes all tags
#
# Tag(id: integer,
#     name: string,
#     created_at: datetime,
#     updated_at: datetime)
##
class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :spins, through: :taggings

  validates :name, presence: true
end
