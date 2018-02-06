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
    let!(:user) { FactoryBot.create(:user) }
    let!(:spin_candidate) { FactoryBot.create(:spin_candidate, user: user) }
    let!(:spin_candidate1) { FactoryBot.create(:spin_candidate, user: user) }

    it '#index' do
      @user = user
      api_basic_authorize
      get "/#{prefix}/spin_candidates"
      expect(response).to have_http_status(:ok)
      data = JSON.parse(response.body)["data"]
      expect(data).to include({
          "id" => spin_candidate.id,
          "full_name" => spin_candidate.full_name,
          "validation_log" => spin_candidate.validation_log,
          "published" => spin_candidate.published,
          "validated" => spin_candidate.validated,
          "last_validation" => spin_candidate.last_validation })
      expect(data).to include ({
          "id" => spin_candidate1.id,
          "full_name" => spin_candidate1.full_name,
          "validation_log" => spin_candidate1.validation_log,
          "published" => spin_candidate1.published,
          "validated" => spin_candidate1.validated,
          "last_validation" => spin_candidate1.last_validation })
    end


    it "show when valid id" do
      @user = user
      api_basic_authorize
      get "/#{prefix}/spin_candidates/#{spin_candidate.id}"
      expect(response).to have_http_status(:ok)
      data = JSON.parse(response.body)["data"]
      expect(data).to include({
          "id" => spin_candidate.id,
          "full_name" => spin_candidate.full_name,
          "validation_log" => spin_candidate.validation_log,
          "published" => spin_candidate.published,
          "validated" => spin_candidate.validated,
          "last_validation" => spin_candidate.last_validation })
    end

    it 'show when invalid id' do
      @user = user
      api_basic_authorize
      get "/#{prefix}/spin_candidates/error"
      expect(response).to have_http_status(:not_found)
    end
    pending "refresh when same repos"
    pending "refresh when deleted repos"
    pending "refresh when new repos"
    pending "refresh when updated repos"
  end
end
