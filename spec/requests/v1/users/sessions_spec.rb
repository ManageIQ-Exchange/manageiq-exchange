require 'rails_helper'

RSpec.describe 'V1::Users::Sessions', type: :request do
  context 'v1' do
    context 'new user' do
      let(:code) { '2931e223feda1c5c331c' }

      it 'creates a new user when it does not exist' do
        VCR.use_cassette('sessions/session-new-user-good-code',
                         :decode_compressed_response => true,
                         :record => :none) do
          headers = {
              params: {
                "code": code,
                "provider": 'github.com'
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

      it 'Throw an error without code param' do
        VCR.use_cassette('sessions/session-new-user-good-code',
                         :decode_compressed_response => true,
                         :record => :none) do
          headers = {
              params: {
                  "provider": 'github.com'
              }
          }
          @identifier = :auth_code_error
          post('/v1/users/sign_in', headers)
          expect(response).to have_http_status(:not_acceptable)
          expect_error
        end
      end

      it 'Throw an error without provider param' do
        VCR.use_cassette('sessions/session-new-user-good-code',
                         :decode_compressed_response => true,
                         :record => :none) do
          headers = {
              params: {
                  "code": code
              }
          }
          @identifier = :auth_provider_error
          post('/v1/users/sign_in', headers)
          expect(response).to have_http_status(:not_acceptable)
          expect_error
        end
      end

      it 'Throw an error without provider provided' do
        VCR.use_cassette('sessions/session-new-user-good-code',
                         :decode_compressed_response => true,
                         :record => :none) do
          headers = {
              params: {
                  "code": code,
                  "provider": 'another_not_provided'
              }
          }
          @identifier = :provider_name_not_provided
          post('/v1/users/sign_in', headers)
          expect(response).to have_http_status(:bad_request)
          expect_error
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
