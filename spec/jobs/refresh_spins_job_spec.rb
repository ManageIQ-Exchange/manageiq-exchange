require 'rails_helper'
require ''
RSpec.describe RefreshSpinsJob, type: :job do
  include ActiveJob::TestHelper

  let!(:user) { FactoryBot.create(:user) }
  let!(:token) {
    @user = user
    api_basic_authorize
  }

  subject(:job) { described_class.perform_later(user, token) }

  pending "add some examples to (or delete) #{__FILE__}"

  let!(:user) { FactoryBot.create(:user) }

  it "Refresh spins of specific user" do
    ActiveJob::Base.queue_adapter = :test
    expect {
      RefreshSpinsJob.perform_later(@user, token)
    }.to have_enqueued_job
  end

  it 'queues the job' do
    expect { job }
        .to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end

  it 'is in default queue' do
    expect(RefreshSpinsJob.new.queue_name).to eq('default')
  end

  it 'executes perform' do
    expect(SourceControlServer).to receive(:repos)
    perform_enqueued_jobs { job }
  end

  it 'handles no results error' do
    allow(SourceControlServer).to receive(:repos)

    perform_enqueued_jobs do
      expect_any_instance_of(RefreshSpinsJob)
          .to receive(:retry_job).with(wait: 10.minutes, queue: :default)

      job
    end
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end
end
