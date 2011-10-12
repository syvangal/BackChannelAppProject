require 'test_helper'

class LoginsControllerTest < ActionController::TestCase
  setup do
    #@login = logins(:one)
  end


  test "user login " do
    @user= users(:one)
    put :create , {:userName => @user.userName , :password => @user.password , :role => @user.role}
    assert_redirected_to(:controller => "logins")
  end

 test "login as admin " do
    @user= users(:two)
    put :create , {:userName => @user.userName , :password => @user.password , :role => @user.role}
    assert_redirected_to(:controller => "logins")
  end

end