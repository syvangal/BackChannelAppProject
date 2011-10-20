require "test_helper"
require "capybara/rails"

module ActionController
  class IntegrationTest
    include Capybara::DSL

    def register(username,email,password)
      user = User.create(:username => username, :password => password,:email => email)
      user.save!
    end

    def sign_in_as(email, password)
      visit '/'
      click_link_or_button('Login')
      fill_in 'Email', :with => email
      fill_in 'Password', :with => password
      click_link_or_button('Sign in')
    end

    def sign_out
      click_link_or_button('Logout')
    end
  end
end