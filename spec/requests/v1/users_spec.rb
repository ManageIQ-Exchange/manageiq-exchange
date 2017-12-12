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
      let!(:user_john) { FactoryBot.create(:user) }

      it 'gets all users' do
        get "/#{prefix}/users"
        expect(response).to have_http_status(200)
        expect(json).to be_kind_of(Array)
        expect(json.length).to eq(1)
        expect(json[0]['login']).to eq(user_john.github_login)
      end

      it 'get one exist user by login' do
        get "/#{prefix}/users/#{user_john.github_login}"
        expect(response).to have_http_status(200)
        expect(json).to be_kind_of(Hash)
        expect(json['login']).to eq(user_john.github_login)
      end

      it 'get one exist user by id' do
        get "/#{prefix}/users/#{user_john.id}"
        expect(response).to have_http_status(200)
        expect(json).to be_kind_of(Hash)
        expect(json['login']).to eq(user_john.github_login)
      end
    end
  end
end
