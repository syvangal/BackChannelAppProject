require 'test_helper'

class LoginTest < ActiveSupport::TestCase
 test "require all" do
   r = logins.one
   assert_false r.valid?
 end


end