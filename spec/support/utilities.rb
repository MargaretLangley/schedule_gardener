include ApplicationHelper

def sign_in_user(user)
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def visit_signin_and_login(user)
  visit signin_path
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
  # Sign in when not using Capybara as well.
  cookies[:remember_token] = user.remember_token
end

RSpec::Matchers.define :have_error_message do |expected|
  match do |actual|
    actual.should have_selector('div.alert.alert-error', text: expected)
  end

  failure_message_for_should do |actual|
    "expected that #{actual} would have the banner #{expected}"
  end

  failure_message_for_should_not do |actual|
    "expected that #{actual} would not have the banner #{expected}"
  end
end


#$0ft&wher3