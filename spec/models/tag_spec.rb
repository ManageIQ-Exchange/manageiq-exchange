require 'rails_helper'

RSpec.describe Tag, type: :model do
  let(:tag) { FactoryBot.build(:tag) }

  it 'has a valid factory' do
    expect(tag).to be_valid
  end

  it 'is not valid without a name' do
    tag.name = nil
    tag.valid?
    expect(tag.errors[:name]).to include("can't be blank")
  end
end
