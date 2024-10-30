require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_response :unprocessable_entity
    assert_template 'users/new'

    assert_select 'div#error_explanation'
    assert_select 'div.alert.alert-danger', text: /The form contains \d+ errors/

    assert_select 'ul li', text: "Name can't be blank"
    assert_select 'ul li', text: "Email is invalid"
    assert_select 'ul li', text: "Password is too short (minimum is 8 characters)"
    assert_select 'ul li', text: "Password confirmation doesn't match Password" 
  end

  test "valid signup information" do
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty? 
  end
end
