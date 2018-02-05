require 'rails_helper'

RSpec.describe Tagging, type: :model do
  let(:tagging) { FactoryBot.create(:tagging) }

  it 'is not valid without a spin' do
    tagging.spin = nil
    tagging.valid?
    expect(tagging.errors.details[:spin]).to include(error: :blank)
  end
  it 'is always associated to a tag' do
    tagging.tag = nil
    tagging.valid?
    expect(tagging.errors.details[:tag]).to include(error: :blank)
  end

  it 'is destroyed when the spin is destroyed' do
    tagging
    expect(Tagging.count).to eq(1)
    expect{ tagging.spin.destroy }.to change(Tagging, :count).from(1).to(0)
    expect{ tagging.reload }.to raise_exception ActiveRecord::RecordNotFound
  end

  it 'is destroyed when the tag is destroyed' do
    tagging
    expect(Tagging.count).to eq(1)
    expect{ tagging.tag.destroy }.to change(Tagging, :count).from(1).to(0)
    expect{ tagging.reload }.to raise_exception ActiveRecord::RecordNotFound
  end
end
