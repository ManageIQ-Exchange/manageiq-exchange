require 'rails_helper'

RSpec.describe 'V1::Top', type: :request do

  describe "GET #index" do
    it "returns http success" do
      get '/v1/top'
      expect(response).to have_http_status(:success)
      data = JSON.parse(response.body)["data"]
      expect(data).not_to be_nil
      expect(data["Most Starred"]).not_to be_nil
      expect(data["Most Watched"]).not_to be_nil
      expect(data["Most Downloaded"]).not_to be_nil
      expect(data["Top Tags"]).not_to be_nil
      expect(data["Top Contributors"]).not_to be_nil
      expect(data["Newest"]).not_to be_nil
    end
  end
end
