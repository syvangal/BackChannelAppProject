require "test/unit"
require 'integration_test_helper'

class MyTest < ActionDispatch::IntegrationTest

  # Called before every test method runs. Can be used
  # to set up fixture information.
   test "login and browse site" do
    # login via https
    https!
    get "/logins"
    assert_response :success
  end

  test "sign out after sign in" do
    register("test", "usertest@testers.com", "password")
    sign_in_as("usertest@testers.com", "password")
    assert_redirected_to(:controller => "posts", :action => "index")

    sign_out
     assert_redirected_to(:controller => "logins", :action => "index")
  end



   test "create a new post" do
    register("test", "usertest@testers.com", "password")
    sign_in_as("usertest@testers.com", "password")

    post = "new post"
    click_link_or_button('New Post')
    fill_in 'Post', :with => post
    click_link_or_button('Update Post')
    assert_equal(Post.last.post, post)
  end

  test "create a reply for the post" do
    register("test", "usertest@testers.com", "password")
    sign_in_as("usertest@testers.com", "password")

    click_link_or_button('New Post')
    fill_in 'Post', :with => "new post"
    click_link_or_button('Update Post')
    post = Post.last.id

    reply = "new reply"
    visit '/'
    click_link_or_button('Reply')
    fill_in 'Post', :with => reply
    click_link_or_button('Update Post')
    child = Post.last.id

    assert_equal(Post.last.root, false)
    assert_equal(Post.last.post, reply)
  end

  test "unauthorized access" do
    visit '/view_users'
    assert page.has_content?("You are not authorized to view this page")

    visit '/view_report'
    assert page.has_content?("You are not authorized to view this page")
  end

  test "admin access" do
    register("admin", "admin@testers.com", "adminpassword")
    sign_in_as("admin@testers.com", "adminpassword")

    visit '/view_users'
    assert page.has_content?("All Users")

    visit '/view_report'
    assert page.has_content?("User Report")
  end

   test "access not granted" do
   register("test", "usertest@testers.com", "password")
    sign_in_as("usertest@testers.com", "password")
    sign_out

    register("test", "usertest@testers.com", "password")
    sign_in_as("usertest@testers.com", "password")

    visit '/users'
    assert page.has_content?("You are not authorized to view this page")

    end
end
