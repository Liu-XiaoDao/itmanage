require 'test_helper'

class DeviceservicesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get deviceservices_index_url
    assert_response :success
  end

  test "should get show" do
    get deviceservices_show_url
    assert_response :success
  end

  test "should get edit" do
    get deviceservices_edit_url
    assert_response :success
  end

  test "should get update" do
    get deviceservices_update_url
    assert_response :success
  end

  test "should get destory" do
    get deviceservices_destory_url
    assert_response :success
  end

end
