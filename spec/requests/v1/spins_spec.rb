require 'rails_helper'

RSpec.describe 'V1::Spins', type: :request do

  context 'v1' do
    let!(:prefix) { 'v1' }

    describe '#GET when spin is not found' do
      it 'all spins when there is none' do
        get "/#{prefix}/spins"
        expect(Spin.count).to eq(0)
        expect(response).to have_http_status(:no_content)
      end

      it 'one spin by wrong id' do
        get "/#{prefix}/spins/3232"
        expect(Spin.count).to eq(0)
        expect(response).to have_http_status(:not_found)
      end
    end

    describe '#GET existing spins' do
      let!(:spin) { FactoryBot.create(:spin, published: true, visible: true) }
      let!(:user) { FactoryBot.create(:user) }
      let!(:spin_exchange) { FactoryBot.create(:spin, name: "exchange",user: user, published: true, visible: true) }
      let!(:spin_content) { FactoryBot.create(:spin, name: "content",user: user, published: true, visible: true) }

      it 'all spins' do
        get "/#{prefix}/spins"
        expect(response).to have_http_status(200)
        expect(json).to be_kind_of(Hash)
        expect(json['data']).to be_kind_of(Array)
        expect(json['data'].length).to eq(3)
      end

      it 'all spins of an existing user' do
        get "/#{prefix}/users/#{user.github_login}/spins"
        expect(response).to have_http_status(200)
        expect(json).to be_kind_of(Hash)
        expect(json['data']).to be_kind_of(Array)
        expect(json['data'].length).to eq(2)
      end

      it 'one spin  by name' do
        get "/#{prefix}/spins/#{spin_exchange.name}"
        expect(response).to have_http_status(200)
        expect(json).to be_kind_of(Hash)
        expect(json['data']).to be_kind_of(Hash)
        expect(json['data']['name']).to eq(spin_exchange.name)
      end

      it 'one spin of a user by name' do
        get "/#{prefix}/users/#{user.github_login}/spins/#{spin_exchange.name}"
        expect(response).to have_http_status(200)
        expect(json).to be_kind_of(Hash)
        expect(json['data']).to be_kind_of(Hash)
        expect(json['data']['name']).to eq(spin_exchange.name)
      end

      it 'one spin by id' do
        get "/#{prefix}/spins/#{spin_content.id}"
        expect(response).to have_http_status(200)
        expect(json).to be_kind_of(Hash)
        expect(json['data']).to be_kind_of(Hash)
        expect(json['data']['name']).to eq(spin_content.name)
      end

      it 'one spin of a user by id' do
        get "/#{prefix}/users/#{user.github_login}/spins/#{spin_content.id}"
        expect(response).to have_http_status(200)
        expect(json).to be_kind_of(Hash)
        expect(json['data']).to be_kind_of(Hash)
        expect(json['data']['name']).to eq(spin_content.name)
      end



      pending 'search for spins of a user'
      pending 'search when there is no user'

      it 'spins with query' do
        get "/#{prefix}/spins?name=exchange"
        expect(response).to have_http_status(200)
        expect(json).to be_kind_of(Hash)
        expect(json['data']).to be_kind_of(Array)
        expect(json['data'].length).to eq(1)
        get "/#{prefix}/spins?name=sample"
        expect(response).to have_http_status(204)
      end
    end
  end
end
