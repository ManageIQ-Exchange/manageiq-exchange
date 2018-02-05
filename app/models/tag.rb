###
# Tag Class
# Includes all tags in the system (lowercase)
#
#
# Tag
#     id: integer,
#     name: string,
#     created_at: datetime,
#     updated_at: datetime
##
class Tag < ApplicationRecord
  # Represents the tags in the system
  has_many :taggings, dependent: :destroy
  has_many :spins, through: :taggings

  validates :name, presence: true, uniqueness: true
  before_save :name_to_lower

  # Returns similar tags if found or nil
  # @return [formated String] Similar tags
  # @return [nil] no match
  def find_similar
    seed_data.each do |tag, candidates|
      candidates.each do |candidate|
        return "Maybe the tag #{name} is wrong. Did you mean #{tag}?" if name.match(/#{candidate}/) && name!=tag
      end
    end
    nil
  end

  private

  def name_to_lower
    self.name = self.name&.parameterize
  end

  def seed_file_name
    @seed_file_name ||= Rails.root.join('product', 'validate_tags.yml')
  end

  def seed_data
    @seed_data ||= File.exist?(seed_file_name) ? YAML.load_file(seed_file_name) : []
  end
end
