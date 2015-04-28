include ApplicationHelper

# logs in
#  - assumes we are on signin_path
#
def login_user(user)
  fill_in 'Email',    with: user.email
  fill_in 'Password', with: user.password
  click_button 'Sign in'
end

# visits and logs in
#
def visit_signin_and_login(user)
  visit signin_path
  fill_in 'Email',    with: user.email
  fill_in 'Password', with: user.password
  click_button 'Sign in'
end

# Fail to login
#
def fail_login_user
  click_button 'Sign in'
end
