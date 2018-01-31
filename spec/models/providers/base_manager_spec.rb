require 'rails_helper'

RSpec.describe Providers::BaseManager, type: :model do
  subject { Providers::BaseManager.new('github.com') }
  it 'initialize correctly' do
    expect(subject).to be_a_kind_of Providers::BaseManager
    expect(subject.identifier).to eq 'github.com'
    expect(subject.provider).to be_a Hash
  end

  it 'initialize with wrong provider' do
    wrong_provider = Providers::BaseManager.new('another.com')
    expect(wrong_provider).to be_a_kind_of Providers::BaseManager
    expect(wrong_provider.identifier).to eq 'another.com'
    expect(wrong_provider.provider).to be_a_kind_of ErrorExchange
  end

  it 'validate_provider of a worng provider' do
    expect(subject.validate_provider('another_repo')).to be_a_kind_of ErrorExchange
  end

  it 'validate_provider of a provider' do
    expect(subject.validate_provider('github.com')).to be_truthy
  end

  it 'get_conector of a github provider' do
    expect(subject.get_connector).to be_a_kind_of Providers::GithubManager
  end

  it 'get_conector of a wrong provider' do
    wrong_provider = Providers::BaseManager.new('another.com')
    expect(wrong_provider.get_connector).to be_a_kind_of ErrorExchange
  end
end
