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

  it 'is not valid with a repeated name' do
    tag.save
    another_tag = FactoryBot.build(:tag, name: tag.name)
    another_tag.valid?
    expect(another_tag.errors.details[:name]).to include(error: :taken, value: tag.name)
  end
end
