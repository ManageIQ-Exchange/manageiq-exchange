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
        get "/#{prefix}/spins?query=exchange"
        expect(response).to have_http_status(200)
        expect(json).to be_kind_of(Hash)
        expect(json['data']).to be_kind_of(Array)
        expect(json['data'].length).to eq(1)
        get "/#{prefix}/spins?query=sample"
        expect(response).to have_http_status(204)
      end
    end

    context 'authentication requests' do
      let(:user) { FactoryBot.create(:user) }

      describe '#POST Visible operation' do
        let!(:spin) { FactoryBot.create(:spin) }
        let!(:spin_exchange) { FactoryBot.create(:spin, name: "exchange",user: user, published: false) }

        it 'Set visible of a not found spin without authenticated' do
          post("/#{prefix}/spins/000323/visible/true")
          expect(response).to have_http_status(401)
        end

        it 'Set visible of a not found spin with authentication' do
          @user = user
          @identifier = :spin_not_found
          api_basic_authorize
          post("/#{prefix}/spins/000323/visible/true")
          expect(response).to have_http_status(:not_found)
          expect_error
        end

        it 'Set visible of a spin of other user' do
          @user = user
          @identifier = :spin_not_owner
          api_basic_authorize
          post("/#{prefix}/spins/#{spin.id}/visible/true")
          expect(response).to have_http_status(:unauthorized)
          expect_error
        end

        it 'Set visible of a spin not published' do
          @user = user
          @identifier = :spin_not_published
          api_basic_authorize
          post("/#{prefix}/spins/#{spin_exchange.id}/visible/true")
          expect(response).to have_http_status(:method_not_allowed)
          expect_error
        end

        it 'Set visible of a spin published' do
          spin_exchange.published = true
          spin_exchange.save
          @user = user
          api_basic_authorize
          post("/#{prefix}/spins/#{spin_exchange.id}/visible/true")
          expect(response).to have_http_status(:accepted)
        end
      end

      describe '#POST Published operation' do
        let!(:spin) { FactoryBot.create(:spin) }
        let!(:spin_exchange) { FactoryBot.create(:spin, name: "exchange", full_name: 'miq-consumption/miq_exchange_demo_repo', user: user, published: false) }

        it 'Publish a not found spin without authenticated' do
          post("/#{prefix}/spins/000323/publish/true")
          expect(response).to have_http_status(401)
        end

        it 'Publish of a not found spin with authentication' do
          @user = user
          @identifier = :spin_not_found
          api_basic_authorize
          post("/#{prefix}/spins/000323/publish/true")
          expect(response).to have_http_status(:not_found)
          expect_error
        end

        it 'Publish of a spin of other user' do
          @user = user
          @identifier = :spin_not_owner
          api_basic_authorize
          post("/#{prefix}/spins/#{spin.id}/publish/true")
          expect(response).to have_http_status(:unauthorized)
          expect_error
        end

        it 'Publish a spin with no releases' do
          spin_exchange.published = true
          spin_exchange.save
          @user = user
          api_basic_authorize
          VCR.use_cassette("providers/github/get_readme",:decode_compressed_response => true,:record => :none) do
            VCR.use_cassette("providers/github/get_metadata",:decode_compressed_response => true,:record => :none) do
              VCR.use_cassette("providers/github/get_releases",:decode_compressed_response => true,:record => :none) do
                post("/#{prefix}/spins/#{spin_exchange.id}/publish/true")
                expect(response).to have_http_status(:method_not_allowed)
                spin_exchange.reload
                expect(spin_exchange.log).to eq '[ERROR] The Spin should have at least a release, please add it to the source control and refresh the Spin'
              end
            end
          end
        end

        it 'Publish a spin2' do
          spin_exchange.published = true
          spin_exchange.save
          @user = user
          api_basic_authorize
          VCR.use_cassette("providers/github/get_readme",:decode_compressed_response => true,:record => :none) do
            VCR.use_cassette("providers/github/get_metadata",:decode_compressed_response => true,:record => :none) do
              VCR.use_cassette("providers/github/get_releases",:decode_compressed_response => true,:record => :none) do
                spin_exchange.update_releases(user)
                post("/#{prefix}/spins/#{spin_exchange.id}/publish/true")
                expect(response).to have_http_status(:accepted)
              end
            end
          end
        end
      end
    end
  end
end
