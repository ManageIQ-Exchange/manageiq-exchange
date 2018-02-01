require 'rails_helper'

RSpec.describe Spin, type: :model do
  let!(:spin) { FactoryBot.create(:spin) }
  let!(:user) { FactoryBot.create(:user) }
  let!(:spin_exchange) { FactoryBot.create(:spin, name: "exchange", full_name: 'miq-consumption/miq_exchange_demo_repo',user: user, published: true, visible:true) }
  let!(:spin_content) { FactoryBot.create(:spin, name: "content",user: user) }

  it 'visible?' do
    expect(spin_exchange.visible?).to be_truthy
    expect(spin_content.visible?).to be_falsey
  end

  it 'publish?' do
    expect(spin_exchange.publish?).to be_truthy
    expect(spin_content.publish?).to be_falsey
  end

  it 'spin_of?' do
    expect(spin_exchange.spin_of?(user)).to be_truthy
    expect(spin.spin_of?(user)).to be_falsey
  end

  it 'visible_to' do
    expect(spin_exchange.visible_to(false)).to be_truthy
    expect(spin_exchange.visible).to be_falsey
    expect(spin_exchange.visible_to(true)).to be_truthy
    expect(spin_exchange.visible).to be_truthy
    expect(spin_content.visible_to(false)).to be_falsey
    expect(spin_content.visible).to be_falsey
    expect(spin_content.visible_to(true)).to be_falsey
    expect(spin_content.visible).to be_falsey
  end

  it 'spin_log' do
    error_message = "Error in metadata"
    expect(spin_exchange.spin_log(error_message)).not_to be_nil
    expect(spin_exchange.log).to eq(error_message)
  end

  it 'validate_readme?' do
    @user = user
    api_basic_authorize
    VCR.use_cassette('providers/github/get_readme',
                     :decode_compressed_response => true,
                      :record => :none) do
      expect(spin_exchange.validate_readme?(user)).to be_truthy
    end
  end

  it 'validate_metadata?' do
    @user = user
    api_basic_authorize
    VCR.use_cassette('providers/github/get_metadata',
                     :decode_compressed_response => true,
                     :record => :none) do
      expect(spin_exchange.validate_metadata?(user)).to be_truthy
    end
  end

  it 'validate_spin? without releases' do
    @user = user
    api_basic_authorize
    VCR.use_cassette("providers/github/get_readme",:decode_compressed_response => true,:record => :none) do
      VCR.use_cassette("providers/github/get_metadata",:decode_compressed_response => true,:record => :none) do
        expect(spin_exchange.validate_spin?(user)).to be_falsey
      end
    end
  end

  it 'validate_releases?' do
    @user = user
    api_basic_authorize
    VCR.use_cassette("providers/github/get_releases",:decode_compressed_response => true,:record => :none) do
      expect(spin_exchange.validate_releases?).to be_falsey
      expect(spin_exchange.log).to eq 'Error in releases, you need  a release in your spin, if you have one refresh the spin'
      expect(spin_exchange.releases).to eq []
      expect(spin_exchange.update_releases(user)). to be_truthy
      expect(spin_exchange.releases).not_to be_empty
      expect(spin_exchange.validate_releases?).to be_truthy
    end
  end

  it 'validate_spin? with releases' do
    @user = user
    api_basic_authorize
    VCR.use_cassette("providers/github/get_readme",:decode_compressed_response => true,:record => :none) do
      VCR.use_cassette("providers/github/get_metadata",:decode_compressed_response => true,:record => :none) do
        VCR.use_cassette("providers/github/get_releases",:decode_compressed_response => true,:record => :none) do
          expect(spin_exchange.update_releases(user)). to be_truthy
          expect(spin_exchange.validate_spin?(user)).to be_truthy
        end
      end
    end
  end

  it 'update_releases' do
    @user = user
    api_basic_authorize
    VCR.use_cassette("providers/github/get_releases",:decode_compressed_response => true,:record => :none) do
       spin_exchange.releases = []
       spin_exchange.save
       expect(spin_exchange.update_releases(user)).to be_truthy
       expect(spin_exchange.releases).not_to be_empty
    end
  end

  it 'refresh_tags' do
    @user = user
    api_basic_authorize
    VCR.use_cassette('providers/github/get_metadata',
                     :decode_compressed_response => true,
                     :record => :none) do
      expect(spin_exchange.validate_metadata?(user)).to be_truthy
      spin_exchange.refresh_tags
      expect(spin_exchange.tags.count).to eq 2
    end
  end

  it 'generate a log by a tag' do
    @user = user
    api_basic_authorize
    VCR.use_cassette('providers/github/get_metadata',
                     :decode_compressed_response => true,
                     :record => :none) do
      expect(spin_exchange.validate_metadata?(user)).to be_truthy
      spin_exchange.metadata['tags'] = ['semo']
      spin_exchange.refresh_tags
      expect(spin_exchange.log).to eq 'Maybe the tag semo is wrong. Did you mean demo?. '
    end
  end

  it 'remove all relation tags without delete the tag' do
    tag_a = FactoryBot.create(:tag)
    tag_b = FactoryBot.create(:tag)
    spin_a = FactoryBot.create(:spin, metadata: {'tags':[tag_a.name,tag_b.name]})
    spin_b = FactoryBot.create(:spin, metadata: {'tags':[tag_a.name,tag_b.name]})
    spin_a.tags << tag_a
    spin_a.tags << tag_b
    expect(spin_a.tags.count).to eq 2
    spin_b.tags << tag_a
    spin_b.tags << tag_b
    spin_b.refresh_tags
    expect(spin_a.tags.count).to eq 2
  end
end
