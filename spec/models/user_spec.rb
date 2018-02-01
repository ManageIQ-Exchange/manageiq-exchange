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
      expect(user.errors.details).to include(:id => [{:error => :blank}])
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

    it 'admin is true or false' do
      [true, false].each do |x|
        user.admin = x
        user.valid?
        expect(user).to be_valid
      end

      user.admin = nil
      user.valid?
      expect(user.errors.details).to include(admin: [{error: :inclusion, value: nil}])
    end

    it 'staff is true or false' do
      [true, false].each do |x|
        user.staff = x
        user.valid?
        expect(user).to be_valid
      end

      user.staff = nil
      user.valid?
      expect(user.errors.details).to include(staff: [{error: :inclusion, value: nil}])
    end
    it 'is valid with an integer karma' do
      user.karma = 90
      user.valid?
      expect(user).to be_valid
    end

    it 'is invalid with a non integer karma' do
      user.karma = 90.1
      user.valid?
      expect(user.errors.details[:karma]).to include({error: :not_an_integer, value: 90.1})

      user.karma = 'hola'
      user.valid?
      expect(user.errors.details[:karma]).to include({error: :not_a_number, value: 'hola'})

      user.karma = nil
      user.valid?
      expect(user.errors.details[:karma]).to include({error: :not_a_number, value: nil})
    end

    it 'is valid with a nil github_avatar_url' do
      user.github_avatar_url = nil
      user.valid?
      expect(user).to be_valid
    end

    it 'is not valid with a nil github_html_url' do
      user.github_html_url = nil
      user.valid?
      expect(user.errors.details[:github_html_url]).to include({:error=>:blank})
    end

    it 'is not valid with a nil github_html_url' do
      user.github_html_url = nil
      user.valid?
      expect(user.errors.details[:github_html_url]).to include({:error=>:blank})
    end

    it 'is not valid without a github_id' do
      user.github_id = nil
      user.valid?
      expect(user.errors.details[:github_id]).to include({error: :blank})
    end

    it 'is not valid with a non-numeric github_id' do
      ['hola', 'aa744432223', 15.2].each do |x|
        user.github_id = x
        user.valid?
        expect(user.errors.details[:github_id]).to include({error: :invalid, value: x.to_s})
      end
    end

    it 'is not valid without a github_login' do
      user.github_login = nil
      user.valid?
      expect(user.errors.details[:github_login]).to include({error: :blank})
    end

    it 'is valid without a github_company ' do
      user.github_company = nil
      user.valid?
      expect(user).to be_valid
    end

    it 'is not valid without a github_type' do
      user.github_type = nil
      user.valid?
      expect(user.errors.details[:github_type]).to include({error: :blank})
    end

    it 'is valid without a github_blog' do
      user.github_blog = nil
      user.valid?
      expect(user).to be_valid
    end

    it 'is valid without an email' do
      user.email = nil
      user.valid?
      expect(user).to be_valid
    end

    pending 'is valis with a list of valid emails'

    pending 'is not valid with a non valid email'
  end
end

