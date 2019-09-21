require 'test_helper'

class LeavesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get leaves_index_url
    assert_response :success
  end

end
