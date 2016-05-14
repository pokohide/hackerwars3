require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  test "should get pushed" do
    get :pushed
    assert_response :success
  end

  test "should get pulled" do
    get :pulled
    assert_response :success
  end

end
