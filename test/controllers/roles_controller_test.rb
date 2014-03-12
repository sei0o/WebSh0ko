require 'test_helper'

class RolesControllerTest < ActionController::TestCase
  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get edit" do
    get :edit
    assert_response :success
  end

  test "should get delete" do
    get :delete
    assert_response :success
  end

  test "should get authorization" do
    get :authorization
    assert_response :success
  end

  test "should get deauthorization" do
    get :deauthorization
    assert_response :success
  end

end
