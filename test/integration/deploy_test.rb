require 'test_helper'

API_VERSION = 1.0

class DeployTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test 'basic api test' do
    get '/'
    assert_response :success
    assert_equal 'application/json', @response.content_type
    assert_equal '{"data":{"version":1.0}}', @response.body
  end
end
