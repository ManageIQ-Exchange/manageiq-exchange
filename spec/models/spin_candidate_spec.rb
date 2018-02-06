require 'rails_helper'

RSpec.describe SpinCandidate, type: :model do
  let(:spin_candidate)   { FactoryBot.build(:spin_candidate) }
  let!(:user) { FactoryBot.create(:user) }
  let(:non_valid_repo)   { 'ManageIQ-Exchange/manageiq-exchange' }
  let(:nonexisting_repo) { 'ManageIQ-Exchange/i_do-not_exist' }
  let(:valid_repo)       { 'ManageIQ-Exchange/manageiq-exchange-spin-template' }
  it 'has a valid factory' do
    spin_candidate.valid?
    expect(spin_candidate).to be_valid
  end

  it 'is not valid without a user' do
    spin_candidate.user = nil
    spin_candidate.valid?
    expect(spin_candidate.errors.details[:user]).to include(error: :blank)
  end

  it 'is not valid without a full name' do
    spin_candidate.full_name = nil
    spin_candidate.valid?
    expect(spin_candidate.errors.details[:full_name]).to include(error: :blank)
  end

  it 'is not valid without a validation_log' do
    spin_candidate.validation_log = nil
    spin_candidate.valid?
    expect(spin_candidate.errors.details[:validation_log]).to include(error: :blank)
  end

  it 'verifies a non-valid repo' do
    spin_candidate.full_name = non_valid_repo
    @user = user
    api_basic_authorize
    VCR.use_cassette('providers/github/spins/get-non-valid-repo') do
      expect(spin_candidate.is_candidate?(user: user)).to be_falsy
    end

  end

  it 'verifies a non-existing repo' do
    spin_candidate.full_name = nonexisting_repo
    @user = user
    api_basic_authorize
    VCR.use_cassette('providers/github/spins/get-non-existing-repo') do
      expect(spin_candidate.is_candidate?(user: user)).to be_falsy
    end

  end

  it 'verifies a valid repo' do
    spin_candidate.full_name = valid_repo
    @user = user
    api_basic_authorize
    VCR.use_cassette('providers/github/spins/get-valid-repo') do
      expect(spin_candidate.is_candidate?(user: user)).to be_truthy
    end
  end
end
