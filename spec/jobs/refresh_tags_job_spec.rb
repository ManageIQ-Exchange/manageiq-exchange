require 'rails_helper'

RSpec.describe RefreshTagsJob, type: :job do
  describe "#perform_later" do
    it "Refresh tags " do
      ActiveJob::Base.queue_adapter = :test
      expect {
        RefreshTagsJob.perform_later()
      }.to have_enqueued_job
    end
  end
end
