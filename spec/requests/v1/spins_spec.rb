require 'rails_helper'

RSpec.describe 'V1::Spins', type: :request do
  let(:prefix) { 'v1' }

  context 'v1' do
    describe 'GET not existing spins' do
      it 'gets all users when there is not users' do
        get "/#{prefix}/spins"
        expect(response).to have_http_status(:no_content)
      end

      it 'get one no exist spin by id' do
        get "/#{prefix}/spins/3232"
        expect(response).to have_http_status(404)
      end
    end

    describe 'GET existing spins' do
      let!(:spin) { FactoryBot.create(:spin) }
      let!(:user) { FactoryBot.create(:user) }
      let!(:spin_galaxy) { FactoryBot.create(:spin, name: "galaxy",user: user) }
      let!(:spin_content) { FactoryBot.create(:spin, name: "content",user: user) }

      it 'gets all spins' do
        get "/#{prefix}/spins"
        expect(response).to have_http_status(200)
        expect(json).to be_kind_of(Array)
        expect(json.length).to eq(3)
        expect(json[0]['name']).to eq(spin.name)
      end

      it 'get all spins of a user' do
        get "/#{prefix}/users/#{user.github_login}/spins"
        expect(response).to have_http_status(200)
        expect(json).to be_kind_of(Array)
        expect(json.length).to eq(2)
      end

      it 'get one exist spin of a user by name' do
        get "/#{prefix}/users/#{user.github_login}/spins/#{spin_galaxy.name}"
        expect(response).to have_http_status(200)
        expect(json).to be_kind_of(Hash)
        expect(json['name']).to eq(spin_galaxy.name)
      end

      it 'get one exist spin of a user by id' do
        get "/#{prefix}/users/#{user.github_login}/spins/#{spin_content.id}"
        expect(response).to have_http_status(200)
        expect(json).to be_kind_of(Hash)
        expect(json['name']).to eq(spin_content.name)
      end

      it 'get spins where name include query value' do
        get "/#{prefix}/spins?query=galaxy"
        expect(response).to have_http_status(200)
        expect(json).to be_kind_of(Array)
        expect(json.length).to eq(1)
        get "/#{prefix}/spins?query=sample"
        expect(response).to have_http_status(204)
      end
    end
  end
end
