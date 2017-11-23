require 'test_helper'

class ConsumablesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get consumables_index_url
    assert_response :success
  end

  test "should get new" do
    get consumables_new_url
    assert_response :success
  end

  test "should get edit" do
    get consumables_edit_url
    assert_response :success
  end

  test "should get update" do
    get consumables_update_url
    assert_response :success
  end

  test "should get show" do
    get consumables_show_url
    assert_response :success
  end

  test "should get create" do
    get consumables_create_url
    assert_response :success
  end

end
