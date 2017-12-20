require 'rails_helper'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr_cassettes/sessions'
  config.hook_into :webmock
  config.filter_sensitive_data('CLIENT-ID') do |interaction|
    (Rack::Utils.parse_query URI(interaction.request.uri).query)['client_id']
  end
  config.filter_sensitive_data('CLIENT-SECRET') do |interaction|
    (Rack::Utils.parse_query URI(interaction.request.uri).query)['client_secret']
  end
  config.filter_sensitive_data('GITHUB-TOKEN') do |interaction|
    JSON.parse(interaction.response.body)['access_token']
  end
  config.filter_sensitive_data('AUTHENTICATION-TOKEN') do |interaction|
    data = JSON.parse(interaction.response.body)['data']
    data['authentication_token'] if data
  end

  config.configure_rspec_metadata!
  config.default_cassette_options = {
      match_requests_on: [:method,
                          VCR.request_matchers.uri_without_param(:client_id, :client_secret, :access_token)]
  }
  # config.debug_logger = File.open("log/github_connection.log", 'w')
end

RSpec.describe 'V1::Users::Sessions', type: :request do
  context 'v1' do
    context 'new user' do
      let(:code) { 'b10f1847f4fef3dd2b1d' }

      it 'creates a new user when it does not exist' do
        VCR.use_cassette('session-new-user-good-code') do
          headers = {
              params: {
                "code": code
              }
          }
          expect { post('/v1/users/sign_in',
                        headers)
          }.to change(User, :count).from(0).to(1)
          expect(response).to have_http_status(:ok)
          expect(response.body).to include "authentication_token"
          expect(response.body).to include "user"
        end
      end
      pending 'fails when the profile is not public'
      pending 'fails when the new user data is not accessible'
    end
    context 'existing user' do
      let(:code) { 'b10f1847f4fef3dd2b1d' }
      let(:user_id) { ''}
      let(:user_token) { '' }
      let(:user) { FactoryBot.create(id: user_id)}

      context '#create session' do
        pending 'fails with a code that is not current'
        pending 'allows the user to create a session when the code is right'
        pending 'reuses TOKEN and ID if present (no new authorization)'
      end
      context '#destroy session' do
        pending 'destroys the session'
        pending 'destroys authentication server session'
      end
    end
  end
end
