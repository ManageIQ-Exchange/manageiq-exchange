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
RSpec.describe SourceControlHelper, type: :helper do
  context 'GitHub' do
    let(:code) { 'cae83aa5fb93c27e2a7f' }
    let(:code_good) { '7101201566bdec1aa9cd' }
    context 'code' do
      it 'gets error code when code is wrong or expired' do
        VCR.use_cassette('sessions/octokit-github-bad-code',
                         :decode_compressed_response => true,
                         :record                     => :none) do
          token = source_control_server.exchange_code_for_token!(code)
          expect(token[:error]).to eq('bad_verification_code')
        end
      end
      it 'gets good authentication token' do
        VCR.use_cassette('sessions/octokit-github-good',
                         :decode_compressed_response => true,
                         :record                     => :none) do
          token = source_control_server.exchange_code_for_token!(code_good)
          expect(token[:error]).to            be_nil
          expect(token[:token_type]).to       eq('bearer')
          expect(token[:access_token]).not_to be_nil
        end
      end
    end
  end
end
