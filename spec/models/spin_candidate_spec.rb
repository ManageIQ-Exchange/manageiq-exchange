require 'rails_helper'

RSpec.describe SpinCandidate, type: :model do
  let(:spin_candidate)   { FactoryBot.build(:spin_candidate) }

  it 'has a valid factory' do
    spin_candidate.valid?
    expect(spin_candidate).to be_valid
  end

  it 'is not valid without a user' do
    spin_candidate.user = nil
    spin_candidate.valid?
    expect(spin_candidate.errors.details[:user]).to include(error: :blank)
  end

  it 'is valid without a spin_candidate' do
    expect(spin_candidate.spin).to be_nil
    spin_candidate.valid?
    expect(spin_candidate).to be_valid
  end

  it 'is valid with a booleand published' do
    [true, false].each do |x|
      spin_candidate.published = x
      spin_candidate.valid?
      expect(spin_candidate).to be_valid
    end
  end

  it 'is not valid with a nil published' do
    spin_candidate.published = nil
    spin_candidate.valid?
    expect(spin_candidate.errors.details[:published]).to include({:error=>:inclusion, :value=>nil})
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
end
