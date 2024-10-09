require "test_helper"

class StaticPageControllerTest < ActionDispatch::IntegrationTest
  test "should get bar" do
    get static_page_bar_url
    assert_response :success
  end

  test "should get baz" do
    get static_page_baz_url
    assert_response :success
  end
end
