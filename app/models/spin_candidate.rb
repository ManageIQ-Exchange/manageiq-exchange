class SpinCandidate < ApplicationRecord
  belongs_to :user
  has_one :spin, dependent: :destroy
  validates :full_name, :validation_log, presence: true
  validates :published, inclusion: { in: [true, false] }
  validates :validated, inclusion: { in: [true, false] }
end
