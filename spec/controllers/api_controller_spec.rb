require 'rails_helper'

RSpec.describe ApiController, type: :controller do

  describe "GET #version" do
    it "returns http success" do
      get :version
      expect(response).to have_http_status(:success)
    end
  end

end
