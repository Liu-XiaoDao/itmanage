require 'test_helper'

class LogsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get logs_index_url
    assert_response :success
  end

  test "should get new" do
    get logs_new_url
    assert_response :success
  end

  test "should get edit" do
    get logs_edit_url
    assert_response :success
  end

  test "should get update" do
    get logs_update_url
    assert_response :success
  end

  test "should get show" do
    get logs_show_url
    assert_response :success
  end

  test "should get create" do
    get logs_create_url
    assert_response :success
  end

end
