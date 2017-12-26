require 'rails_helper'

RSpec.describe 'V1::Users::Sessions', type: :request do
  context 'v1' do
    context 'new user' do
      let(:code) { 'b10f1847f4fef3dd2b1d' }

      it 'creates a new user when it does not exist' do
        VCR.use_cassette('sessions/session-new-user-good-code') do
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
