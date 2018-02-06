require 'rails_helper'

RSpec.describe 'V1::SpinCandidates', type: :request do
  context "when not authenticated " do
    VCR.use_cassette('spins/spin-candidates-bad-auth') do
      pending '#index returns 401'
      pending '#show returns 401'
      pending '#refresh returns 401'
    end
  end
  context "when authenticated" do
    pending "index"
    pending "show when valid id"
    pending "show when invalid id"
    pending "refresh when same repos"
    pending "refresh when deleted repos"
    pending "refresh when new repos"
    pending "refresh when updated repos"
  end
end
