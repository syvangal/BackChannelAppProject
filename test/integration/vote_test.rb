require 'integration_test_helper'


class VoteTest < ActionDispatch::IntegrationTest
  fixtures :all


  test "vote" do
    page.click_link("Login")
    page.fill_in('User name', :with => 'usertest')
    page.fill_in('Password', :with => 'test')
    click_button("Login")
    page.click_button('Create Post')
    assert_true page.has_content?('0 Votes')
    page.click_button('Vote')
    assert_false page.has_content?('1 Voted')
    page.click_link('Sign Out')
  end

  test "checking multiple vote" do
   page.click_link("Login")
   page.fill_in('User name', :with => 'usertest1')
   page.fill_in('Password', :with => 'test1')
   click_button("Login")
   assert_true page.has_content?('0 Votes')
   page.click_button('Vote')
   page.click_button('Vote')
   assert_false page.has_content?('1 Voted')
  end

  test "voting for replies" do
    page.click_link("Login")
    page.fill_in('User name', :with => 'usertest1')
    page.fill_in('Password', :with => 'test1')
    click_button("Login")
    assert_false page.has_content?("0 Votes")
    find_button("reply").click
    assert page.has_content?("1 Voted")
  end

  test "multiple voting for replies" do
   page.click_link("Login")
   page.fill_in('User name', :with => 'usertest1')
   page.fill_in('Password', :with => 'test1')
   click_button("Login")
   assert_false page.has_content?("1 voted")
   find_button("reply").click
   find_button("reply").click
   find_button("reply").click
   assert page.has_content?("1 Voted")
  end

end