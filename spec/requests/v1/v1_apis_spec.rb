require 'rails_helper'

RSpec.describe 'V1::Api', type: :request do
  let(:version) { '1.0' }
  let(:prefix) { 'v1' }
  let(:controller) { "#{prefix}/api" }

  context 'v1' do
    describe 'GET static data in API' do
      it 'gets the API version when it GET root' do
        get '/'
        expect(response).to have_http_status(200)
        expect(response.content_type).to eq('application/json')
        expect(response.charset).to eq('utf-8')
        expect(response.body).to eq("{\"data\":{\"version\":\"#{version}\"}}")
      end

      it 'gets the API version' do
        get '/v1/api/version'
        expect(response).to have_http_status(200)
        expect(response.content_type).to eq('application/json')
        expect(response.charset).to eq('utf-8')
        expect(response.body).to eq("{\"data\":{\"version\":\"#{version}\"}}")
      end
    end
  end
  context 'latest' do
    describe 'latest is aliased to PREFIX' do
      it 'gets the API version for latest as PREFIX' do
        get '/api/version'
        expect(request.filtered_parameters['controller']).to eq(controller)
        expect(response.content_type).to eq('application/json')
        expect(response.charset).to eq('utf-8')
      end
    end
  end
end
