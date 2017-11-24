require 'rails_helper'

RSpec.describe "V1::Api", type: :request do
  context "v1" do
    VERSION = 1.0
    describe "GET static data in API" do
      it "gets the API version when it GET root" do
        get '/'
        expect(response).to have_http_status(200)
        expect(response.content_type).to eq('application/json')
        expect(response.charset).to eq('utf-8')
        expect(response.body).to eq("{\"data\":{\"version\":#{VERSION}}}")
      end

      it "gets the API version" do
        get '/v1/api/version'
        expect(response).to have_http_status(200)
        expect(response.content_type).to eq('application/json')
        expect(response.charset).to eq('utf-8')
        expect(response.body).to eq("{\"data\":{\"version\":#{VERSION}}}")
      end
    end
  end
  context "latest" do
    VERSION = 1.0
    PREFIX = "v1"
    CONTROLLER = "#{PREFIX}/api"
    describe "latest is aliased to #{PREFIX}" do
      it "gets the API version for latest as #{PREFIX}" do
        get '/latest/api/version'
        expect(request.filtered_parameters["controller"]).to eq(CONTROLLER)
        expect(response.content_type).to eq('application/json')
        expect(response.charset).to eq('utf-8')
      end
    end
  end
end
