require 'integration_test_helper'

class SearchTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "search by content" do
    visit('/logins')
    fill_in("search", :with => "admin")
    click_link("searchContent")
    assert page.has_content?("admin")
  end

  test "search by user" do
    visit('/logins')
    fill_in("search", :with => "user1")
    select("Username", :from => "search_by")
    click_link("searchUser")
    assert page.has_content?("user1")

  end

end