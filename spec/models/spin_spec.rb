require 'rails_helper'

RSpec.describe Spin, type: :model do
  let!(:spin) { FactoryBot.create(:spin) }
  let!(:user) { FactoryBot.create(:user) }
  let!(:spin_galaxy) { FactoryBot.create(:spin, name: "galaxy", full_name: 'miq-consumption/galaxy_demo_repos',user: user, published: true, visible:true) }
  let!(:spin_content) { FactoryBot.create(:spin, name: "content",user: user) }

  it 'visible?' do
    expect(spin_galaxy.visible?).to be_truthy
    expect(spin_content.visible?).to be_falsey
  end

  it 'publish?' do
    expect(spin_galaxy.publish?).to be_truthy
    expect(spin_content.publish?).to be_falsey
  end

  it 'spin_of?' do
    expect(spin_galaxy.spin_of?(user)).to be_truthy
    expect(spin.spin_of?(user)).to be_falsey
  end

  it 'visible_to' do
    expect(spin_galaxy.visible_to(false)).to be_truthy
    expect(spin_galaxy.visible).to be_falsey
    expect(spin_galaxy.visible_to(true)).to be_truthy
    expect(spin_galaxy.visible).to be_truthy
    expect(spin_content.visible_to(false)).to be_falsey
    expect(spin_content.visible).to be_falsey
    expect(spin_content.visible_to(true)).to be_falsey
    expect(spin_content.visible).to be_falsey
  end

  it 'spin_log' do
    error_message = "Error in metadata"
    expect(spin_galaxy.spin_log(error_message)).not_to be_nil
    expect(spin_galaxy.log).to eq(error_message)
  end

  it 'validate_readme?' do
    VCR.use_cassette('github/get_readme',
                     :decode_compressed_response => true,
                      :record => :none) do
      expect(spin_galaxy.validate_readme?).to be_truthy
    end
  end

  it 'validate_metadata?' do
    VCR.use_cassette('github/get_metadata',
                     :decode_compressed_response => true,
                     :record => :none) do
      expect(spin_galaxy.validate_metadata?).to be_truthy
    end
  end

  it 'validate_spin? without releases' do
    VCR.use_cassette("github/get_readme",:decode_compressed_response => true,:record => :none) do
      VCR.use_cassette("github/get_metadata",:decode_compressed_response => true,:record => :none) do
        expect(spin_galaxy.validate_spin?).to be_falsey
      end
    end
  end

  it 'validate_releases?' do
    VCR.use_cassette("github/get_releases",:decode_compressed_response => true,:record => :none) do
      expect(spin_galaxy.validate_releases?).to be_falsey
      expect(spin_galaxy.log).to eq 'Error in releases, you need  a release in your spin, if you have one refresh the spin'
      expect(spin_galaxy.releases).to eq []
      expect(spin_galaxy.update_releases). to be_truthy
      expect(spin_galaxy.releases).not_to be_empty
      expect(spin_galaxy.validate_releases?).to be_truthy
    end
  end

  it 'validate_spin? with releases' do
    VCR.use_cassette("github/get_readme",:decode_compressed_response => true,:record => :none) do
      VCR.use_cassette("github/get_metadata",:decode_compressed_response => true,:record => :none) do
        VCR.use_cassette("github/get_releases",:decode_compressed_response => true,:record => :none) do
          expect(spin_galaxy.update_releases). to be_truthy
          expect(spin_galaxy.validate_spin?).to be_truthy
        end
      end
    end
  end

  it 'update_releases' do
    VCR.use_cassette("github/get_releases",:decode_compressed_response => true,:record => :none) do
       spin_galaxy.releases = []
       spin_galaxy.save
       expect(spin_galaxy.update_releases).to be_truthy
       expect(spin_galaxy.releases).not_to be_empty
    end
  end
end
