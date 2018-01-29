require 'rails_helper'

RSpec.describe Providers::GithubManager, type: :model do
  let(:base_manager) { Providers::BaseManager.new('github.com') }
  subject { Providers::GithubManager.new(base_manager.provider) }

  it 'initialize correctly' do
    expect(subject).to be_a_kind_of Providers::GithubManager
    expect(subject.server_type).to eq 'GitHub'
    expect(subject.github_access).to be_a_kind_of Octokit::Client
  end
end
