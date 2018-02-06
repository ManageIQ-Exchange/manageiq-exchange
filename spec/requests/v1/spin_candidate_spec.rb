require 'rails_helper'

RSpec.describe 'V1::SpinCandidates', type: :request do
  let!(:prefix) { 'v1' }

  context 'when not authenticated' do
    it '#index returns 401' do
      get "/#{prefix}/spin_candidates"
      expect(response).to have_http_status(401)
    end

    it '#show returns 401' do
      get "/#{prefix}/spin_candidates/1"
      expect(response).to have_http_status(401)
    end

    it '#publish returns 401' do
      post "/#{prefix}/spin_candidates/1/publish"
      expect(response).to have_http_status(401)
    end

    it '#refresh returns 401' do
      post "/#{prefix}/spin_candidates/refresh"
      expect(response).to have_http_status(401)
    end
  end
  context 'when authenticated' do
    pending "index" 
    pending "show when valid id"
    pending "show when invalid id"
    pending "refresh when same repos"
    pending "refresh when deleted repos"
    pending "refresh when new repos"
    pending "refresh when updated repos"
  end
end
