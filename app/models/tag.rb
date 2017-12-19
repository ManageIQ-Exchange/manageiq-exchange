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

  validates :name, presence: true, uniqueness: true
  before_save :name_to_lower

  private
  def name_to_lower
    self.name = self.name&.parameterize
  end
end
