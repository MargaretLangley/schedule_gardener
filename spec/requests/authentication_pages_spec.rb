require 'spec_helper'


describe "Authentication" do

  let(:user) { FactoryGirl.create(:user) }
  subject { page }

  before  do
    visit signin_path
  end


  it "visits sign in page" do
    current_path.should eq signin_path
  end

  context "signin" do

    context "succeeds" do

      context "for standard user" do
        before { sign_in_user(user) }

        it ("opens protected page")      { current_path.should eq user_path(user) }
        it ("has no 'users' link")       { should_not have_link('Users',      href: users_path) }
        it ("has 'full name' link")      { should have_link( user.full_name,  href: "#") }
        it ("has 'Profile' link")        { should have_link('Profile',        href: user_path(user)) }
        it ("has 'Update Profile' link") { should have_link('Update Profile', href: edit_user_path(user)) }
        it ("has 'Sign out' link ")      { should have_link('Sign out',       href: signout_path) }
      end

      context "for admin user" do
        pending "until authorization gem introduced"
      end
    end

    context "fails for all-users" do
      before { click_button "Sign in" }

      it ("remains on signin page")       { current_path.should eq signin_path }
      it ("has error banner")             { should have_error_message('Invalid') }
      it ("has no 'users' link")          { should_not have_link('Users',          href: users_path) }
      it ("has no 'full name' link")      { should_not have_link( user.full_name,  href: "#") }
      it ("has no 'Profile' link")        { should_not have_link('Profile',        href: user_path(user)) }
      it ("has no 'Update Profile' link") { should_not have_link('Update Profile', href: edit_user_path(user)) }
      it ("has no 'Sign out' link")       { should_not have_link('Sign out',       href: signout_path) }

      describe "after visiting another page" do
        before { click_link "logo" }
        it ("No Error Banner") { should_not have_selector('div.alert.alert-error', "error banner") }
      end
    end
  end

end
