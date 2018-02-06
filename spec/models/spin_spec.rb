#
# Tests for the Spin class

require 'rails_helper'

RSpec.describe Spin, type: :model do
  let!(:spin) { FactoryBot.create(:spin) }
  let!(:user) { FactoryBot.create(:user) }
  let(:non_valid_repo)   { 'ManageIQ-Exchange/manageiq-exchange' }
  let(:nonexisting_repo) { 'ManageIQ-Exchange/i_do-not_exist' }
  let(:valid_repo)       { 'ManageIQ-Exchange/manageiq-exchange-spin-template' }

  before(:each) do
    @user = user
    api_basic_authorize
  end

  it 'has a valid factory' do
    expect(spin).to be_valid
  end

  pending 'is destroyed when the spin candidate is destroyed'
end
