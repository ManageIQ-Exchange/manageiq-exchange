require 'rails_helper'

RSpec.describe 'V1::Metadata', type: :request do
  describe 'Pagination tests ' do
    let!(:prefix) { 'v1' }
    let!(:user_john) { FactoryBot.create(:user, :github_login => "John") }
    let!(:user_tom) { FactoryBot.create(:user, :github_login => "Thomas") }
    let!(:user_johny) { FactoryBot.create(:user, :github_login => "Johny") }

    it 'Check json return' do
      get "/#{prefix}/users?limit=1"
      expect(response).to have_http_status(200)
      expect(json).to be_kind_of(Hash)
      expect(json.length).to eq(2)
      expect(json).to include('data')
      expect(json).to include('meta')
      expect(json['meta']).to be_kind_of(Hash)
    end

    context "Check metadata keys with first page and limit" do
      let!(:result) {
        get "/#{prefix}/users?limit=1"
        json
      }
      it 'Check pagination with limit' do
        expect(result['data'].length).to eq(1)
        expect(result['meta']).to include('current_page','total_pages','total_count','next_page','href_next_page')
      end

      it 'Check counts' do
        expect(result['meta']['current_page']).to eq(1)
        expect(result['meta']['total_pages']).to eq(3)
        expect(result['meta']['total_count']).to eq(3)
        expect(result['meta']['next_page']).to eq(2)
        expect(result['meta']['href_next_page']).to eq('http://www.example.com/v1/users?limit=1&page=2')
      end
    end

    context "Check metadata keys with second page and limit" do
      let!(:result) {
        get "/#{prefix}/users?limit=1&page=2"
        json
      }
      it 'Check pagination with limit' do
        expect(result['data'].length).to eq(1)
        expect(result['meta'].length).to eq(7)
        expect(result['meta']).to include('current_page','total_pages','total_count','next_page','href_next_page','href_previous_page','prev_page')
      end

      it 'Check counts' do
        expect(result['meta']['current_page']).to eq(2)
        expect(result['meta']['total_pages']).to eq(3)
        expect(result['meta']['total_count']).to eq(3)
        expect(result['meta']['next_page']).to eq(3)
        expect(result['meta']['prev_page']).to eq(1)
        expect(result['meta']['href_next_page']).to eq('http://www.example.com/v1/users?limit=1&page=3')
        expect(result['meta']['href_previous_page']).to eq('http://www.example.com/v1/users?limit=1&page=1')
      end
    end

    context "Check metadata keys without limit" do
      let!(:result) {
        get "/#{prefix}/users"
        json
      }
      it 'Check pagination with limit' do
        expect(result['data'].length).to eq(3)
        expect(result['meta'].length).to eq(3)
        expect(result['meta']).to include('current_page','total_pages','total_count')
      end

      it 'Check counts' do
        expect(result['meta']['current_page']).to eq(1)
        expect(result['meta']['total_pages']).to eq(1)
        expect(result['meta']['total_count']).to eq(3)
      end
    end

    context "Check metadata keys without limit and page 2" do
      let!(:result) {
        get "/#{prefix}/users?page=2"
        json
      }
      it 'Check pagination with limit' do
        expect(result['data'].length).to eq(0)
        expect(result['meta'].length).to eq(3)
        expect(result['meta']).to include('current_page','total_pages','total_count')
      end

      it 'Check counts' do
        expect(result['meta']['current_page']).to eq(2)
        expect(result['meta']['total_pages']).to eq(1)
        expect(result['meta']['total_count']).to eq(3)
      end

      pending ("should return error to set a out page")
    end

    context "Check metadata keys without limit and page 1" do
      let!(:result) {
        get "/#{prefix}/users?page=1"
        json
      }
      it 'Check pagination with limit' do
        expect(result['data'].length).to eq(3)
        expect(result['meta'].length).to eq(3)
        expect(result['meta']).to include('current_page','total_pages','total_count')
      end

      it 'Check counts' do
        expect(result['meta']['current_page']).to eq(1)
        expect(result['meta']['total_pages']).to eq(1)
        expect(result['meta']['total_count']).to eq(3)
      end
    end

    context "Check error key without limit and page no integer" do
      let!(:result) {
        get "/#{prefix}/users?page=a"
        json
      }
      it 'Check pagination with limit' do
        expect(result.length).to eq(1)
        expect(result).to include('errors')
      end

      it 'Check error' do
        expect(result['errors']).to eq("Param page is wrong, is_numeric? failed")
      end
    end

    context "Check error key with limit no integer" do
      let!(:result) {
        get "/#{prefix}/users?limit=a"
        json
      }
      it 'Check pagination with limit' do
        expect(result.length).to eq(1)
        expect(result).to include('errors')
      end

      it 'Check error' do
        expect(result['errors']).to eq("Param limit is wrong, is_numeric? failed")
      end
    end


  end
end
