class SpinCandidate < ApplicationRecord
  belongs_to :user
  has_one :spin, dependent: :destroy
  validates :full_name, :validation_log, presence: true
  validates :published, inclusion: { in: [true, false] }
  validates :validated, inclusion: { in: [true, false] }


  def publish_spin user:
    if spin.check user
      spin.visible = true
      if spin.save
        published = true
        return true if save
      end
    end
    false
  end
end
