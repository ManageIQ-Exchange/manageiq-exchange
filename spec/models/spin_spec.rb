#
# Tests for the Spin class

require 'rails_helper'

RSpec.describe Spin, type: :model do
  let!(:spin) { FactoryBot.create(:spin) }
  let!(:user) { FactoryBot.create(:user) }
  let(:non_valid_repo)   { 'ManageIQ-Exchange/manageiq-exchange' }
  let(:nonexisting_repo) { 'ManageIQ-Exchange/i_do-not_exist' }
  let(:valid_repo)       { 'ManageIQ-Exchange/manageiq-exchange-spin-template' }
  let(:metadata_valid) {
    {
        metadata_version: 1, # It must be 1
        description: "Description",
        author: "Author Name",

        min_miq_version: "h",
        # A letter with the manageiq_version:
        # For Hammer, use "h"
        # For Gaprishdanvili, use "g"
        # Etc.

        # max_miq_version: "h"

        tags: ['demo','open source']
    }
  }
  before(:each) do
    @user = user
    api_basic_authorize
  end

  it 'has a valid factory' do
    expect(spin).to be_valid
  end

  pending 'has_valid_metadata?' do
    spin.metadata = metadata_valid
    expect(spin.has_valid_metadata?).to be_truthy
  end

  pending 'has_valid_metadata? is false with nil metadata' do
    spin.metadata = nil
    expect(spin.has_valid_metadata?).to be_falsey
  end

  pending 'has_valid_metadata? is false with empty metadata' do
    spin.metadata = ''
    expect(spin.has_valid_metadata?).to be_falsey
  end

  pending 'has_valid_readme?' do
    spin.readme = 'sample'
    expect(spin.has_valid_readme?).to be_truthy
  end

  pending 'has_valid_readme? is false with nil readme' do
    spin.readme = nil
    expect(spin.has_valid_readme?).to be_falsey
  end

  pending 'has_valid_readme? is false with empty radme' do
    spin.readme = ''
    expect(spin.has_valid_readme?).to be_falsey
  end

  pending 'update_values' do
    spin.full_name = valid_repo
    VCR.use_cassette('providers/github/update_values',
                     :decode_compressed_response => true) do
        expect(spin.update_columns(user)).to be_truthy
    end
  end

  pending 'check' do
    spin.full_name = valid_repo
    VCR.use_cassette('providers/github/update_values',
                     :decode_compressed_response => true) do
      expect(spin.check(user)).to be_truthy
      expect(spin.spin_candidate.validated).to be_truthy
      expect(spin.spin_candidate.validation_log).to include('[OK] Spin is validated')

    end
  end

  pending 'is destroyed when the spin candidate is destroyed'
end
