require "test_helper"

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "layout links for non-logged-in user" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2 
    assert_select "a[href=?]", help_path 
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path

    assert_select "a[href=?]", users_path, count: 0 
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
    assert_select "a[href=?]", edit_user_path(@user), count: 0
  end

  test "layout links for logged-in user" do
    log_in_as(@user)
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2 
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", edit_user_path(@user)
    assert_select "a[href=?]", logout_path 
    assert_select "a[href=?]", about_path 
    assert_select "a[href=?]", contact_path

    assert_select "a[href=?]", login_path, count: 0 
  end

  test "signup page" do
    get signup_path
    assert_template 'users/new'
    assert_select "title", full_title("Sign up")
  end

  test "home page stats display" do
    log_in_as(@user)
    get root_path
    assert_template 'static_pages/home'
    assert_match @user.active_relationships.count.to_s, response.body
    assert_match @user.passive_relationships.count.to_s, response.body
    assert_match @user.microposts.count.to_s, response.body
  end
end
