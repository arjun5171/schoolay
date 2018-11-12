require 'test_helper'

class FranchiseControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get franchise_index_url
    assert_response :success
  end

  test "should get show" do
    get franchise_show_url
    assert_response :success
  end

end
