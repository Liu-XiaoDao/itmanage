require 'test_helper'

class ProcessResourcesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get process_resources_index_url
    assert_response :success
  end

  test "should get new" do
    get process_resources_new_url
    assert_response :success
  end

  test "should get create" do
    get process_resources_create_url
    assert_response :success
  end

  test "should get edit" do
    get process_resources_edit_url
    assert_response :success
  end

  test "should get update" do
    get process_resources_update_url
    assert_response :success
  end

end
