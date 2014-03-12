require 'test_helper'

class SettingsControllerTest < ActionController::TestCase
  test "should get theme" do
    get :theme
    assert_response :success
  end

end
