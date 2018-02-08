class SpinCandidate < ApplicationRecord
  belongs_to :user
  has_one :spin, dependent: :destroy
  validates :full_name, :validation_log, presence: true
  validates :published, inclusion: { in: [true, false] }
  validates :validated, inclusion: { in: [true, false] }

  def is_candidate? user:
    client = Providers::BaseManager.new(user).get_connector
    client.candidate_spin? full_name
  end

  def publish_spin user:
    if spin.check user
      spin.visible = true
      if spin.save
        self.published = true
        return true if save
      end
    end
    false
  end

  def unpublish
    spin.visible = false
    if spin.save
      self.published = false
      return true if save
    end
    false
  end
end
