require "test/unit"
require 'integration_test_helper'

class PostTest < ActionDispatch::IntegrationTest
    fixtures :all

  setup do
    user = User.new
    register("test", "usertest@testers.com", "password")
    sign_in_as("test", "password")

    user = User.new
    register("admin", "admintest@testers.com", "adminpassword")
    sign_in_as("admin", "adminpassword")


    visit("/logins")
    if(page.has_link?("Sign Out"))
      click_link("Sign Out")
    end
  end

  test "user post" do
    click_link("Login")
    fill_in("session_username", :with => "test")
    fill_in("session_password", :with => "password")
    click_button("Login")
    page.fill_in('New Post', :with => 'Testy testerson testing')
    page.click_button('Create Post')
    assert page.has_content?("Testy testerson testing")
    assert_true (page.has_content?('0 Owner'))
    assert_true page.has_content?('No replies to this post')
   end

  end

  test "admin post" do
    click_link("Login")
    fill_in("session_username", :with => "admin")
    fill_in("session_password", :with => "password")
    click_button("Login")
    page.fill_in('New Post', :with => 'Testy testerson testing')
    page.click_button('Create Post')
    assert page.has_content?("Testy testerson testing")
    assert_true (page.has_content?('0 Owner'))
    assert_true page.has_content?('No replies to this post')
  end

