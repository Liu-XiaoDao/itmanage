require 'test_helper'

class OtherservicesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get otherservices_index_url
    assert_response :success
  end

  test "should get show" do
    get otherservices_show_url
    assert_response :success
  end

  test "should get edit" do
    get otherservices_edit_url
    assert_response :success
  end

  test "should get update" do
    get otherservices_update_url
    assert_response :success
  end

  test "should get destory" do
    get otherservices_destory_url
    assert_response :success
  end

end
