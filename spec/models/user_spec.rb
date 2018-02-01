require 'rails_helper'

RSpec.describe User, type: :model do
  context 'basic functionality' do
    let(:user) { FactoryBot.build(:user)}
    it 'has a valid factory' do
      user.valid?
      expect(user).to be_valid
    end
    it 'is not valid without an id' do
      user.id = nil
      user.valid?
      expect(user.errors.details).to include(:id=>[{:error=>:blank}])
    end

    it 'is valid with a name' do
      ['', 'uno', 'dos tres'].each do |x|
        user.name = x
        user.valid?
        expect(user).to be_valid
      end
    end

    it 'is valid with a null name' do
      user.name = nil
      user.valid?
      expect(user).to be_valid
    end

    it 'amin is true or false' do
      [true, false].each do |x|
        user.admin = x
        user.valid?
        expect(user).to be_valid
      end

      user.admin = nil
      user.valid?
      expect(user.errors.details).to include(:admin=>[{:error=>:inclusion, :value=>nil}])
    end
  end
end
