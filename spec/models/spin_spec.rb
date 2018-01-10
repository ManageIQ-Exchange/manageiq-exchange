require 'rails_helper'

RSpec.describe Spin, type: :model do
  let!(:spin) { FactoryBot.create(:spin) }
  let!(:user) { FactoryBot.create(:user) }
  let!(:spin_galaxy) { FactoryBot.create(:spin, name: "galaxy", full_name: 'miq-galaxy/galaxy_demo_repos',user: user, published: true, visible:true) }
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
                     :record                     => :none) do
      expect(spin_galaxy.validate_readme?).to be_truthy
    end
  end

  it 'validate_metadata?' do
    VCR.use_cassette('github/get_metadata',
                     :decode_compressed_response => true,
                     :record                     => :none) do
      expect(spin_galaxy.validate_metadata?).to be_truthy
    end
  end

  it 'validate_spin?' do
    VCR.use_cassette("github/get_readme",:decode_compressed_response => true,:record => :none) do
      VCR.use_cassette("github/get_metadata",:decode_compressed_response => true,:record => :none) do
        expect(spin_galaxy.validate_spin?).to be_truthy
      end
    end
  end
end
