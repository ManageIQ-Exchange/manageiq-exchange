class SpinCandidate < ApplicationRecord
  belongs_to :user
  has_one :spin, dependent: :destroy
  validates :full_name, :validation_log, presence: true
  validates :published, inclusion: { in: [true, false] }
  validates :validated, inclusion: { in: [true, false] }

  def is_candidate? user:
    client = Providers::BaseManager.new(user.authentication_tokens.first.provider).get_connector
    client.candidate_spin? full_name
  end
end
