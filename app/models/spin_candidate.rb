class SpinCandidate < ApplicationRecord
  belongs_to :user
  validates :full_name, :validation_log, presence: true

  def is_candidate? user:
    client = Providers::BaseManager.new(user.authentication_tokens.first.provider).get_connector
    client.candidate_spin? full_name
  end
end
