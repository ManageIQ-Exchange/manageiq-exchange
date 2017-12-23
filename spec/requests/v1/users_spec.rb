require 'rails_helper'

RSpec.describe 'V1::Users', type: :request do
  let(:prefix) { 'v1' }

  context 'v1' do
    describe 'GET not existing users' do
      it 'gets all users when there is not users' do
        get "/#{prefix}/users"
        expect(response).to have_http_status(:no_content)
      end

      it 'get one no exist user by login' do
        get "/#{prefix}/users/john"
        expect(response).to have_http_status(404)
      end

      it 'get one no exist user by id' do
        get "/#{prefix}/users/3232"
        expect(response).to have_http_status(404)
      end
    end

    describe 'GET existing users' do
      let!(:user_john) { FactoryBot.create(:user, :github_login => "John") }
      let!(:user_tom) { FactoryBot.create(:user, :github_login => "Thomas") }
      let!(:user_johny) { FactoryBot.create(:user, :github_login => "Johny") }

      it 'gets all users' do
        get "/#{prefix}/users"
        expect(response).to have_http_status(200)
        expect(json).to be_kind_of(Hash)
        expect(json['data']).to be_kind_of(Array)
        expect(json['data'].length).to eq(3)
        expect(json['data'][0]['login']).to eq(user_john.github_login)
      end

      it 'get one exist user by login' do
        get "/#{prefix}/users/#{user_john.github_login}"
        expect(response).to have_http_status(200)
        expect(json).to be_kind_of(Hash)
        expect(json['data']).to be_kind_of(Hash)
        expect(json['data']['login']).to eq(user_john.github_login)
      end

      it 'get one exist user by id' do
        get "/#{prefix}/users/#{user_john.id}"
        expect(response).to have_http_status(200)
        expect(json).to be_kind_of(Hash)
        expect(json['data']).to be_kind_of(Hash)
        expect(json['data']['login']).to eq(user_john.github_login)
      end

      it 'get users where login include query value' do
        get "/#{prefix}/users?query=ohn"
        expect(response).to have_http_status(200)
        expect(json).to be_kind_of(Hash)
        expect(json['data']).to be_kind_of(Array)
        expect(json['data'].length).to eq(2)
        get "/#{prefix}/users?query=ohny"
        expect(response).to have_http_status(200)
        expect(json).to be_kind_of(Hash)
        expect(json['data']).to be_kind_of(Array)
        expect(json['data'].length).to eq(1)
      end
    end
  end
end
