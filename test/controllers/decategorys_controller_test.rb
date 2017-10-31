require 'test_helper'

class DecategorysControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get decategorys_index_url
    assert_response :success
  end

  test "should get create" do
    get decategorys_create_url
    assert_response :success
  end

  test "should get show" do
    get decategorys_show_url
    assert_response :success
  end

  test "should get update" do
    get decategorys_update_url
    assert_response :success
  end

  test "should get edit" do
    get decategorys_edit_url
    assert_response :success
  end

end
