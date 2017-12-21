require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the SourceControlHelper. For example:
#
# describe SourceControlHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
#

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr_cassettes'
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
  config.configure_rspec_metadata!
  config.default_cassette_options = {
    match_requests_on: [:method,
                        VCR.request_matchers.uri_without_param(:client_id, :client_secret, :access_token)]
  }
  # config.debug_logger = File.open("log/github_connection.log", 'w')
end

RSpec.describe SourceControlHelper, type: :helper do
  context 'GitHub' do
    let(:code) { 'cae83aa5fb93c27e2a7f' }
    let(:code_good) { '7101201566bdec1aa9cd' }
    context 'code' do
      it 'gets error code when code is wrong or expired' do
        VCR.use_cassette('octokit-github-bad-code') do
          token = source_control_server.exchange_code_for_token!(code)
          expect(token[:error]).to eq('bad_verification_code')
        end
      end
      it 'gets good authentication token' do
        VCR.use_cassette('octokit-github-good') do
          token = source_control_server.exchange_code_for_token!(code_good)
          expect(token[:error]).to            be_nil
          expect(token[:token_type]).to       eq('bearer')
          expect(token[:access_token]).not_to be_nil
        end
      end
    end
  end
end
