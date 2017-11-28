require 'test_helper'

class PartcategorysControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get partcategorys_index_url
    assert_response :success
  end

end
