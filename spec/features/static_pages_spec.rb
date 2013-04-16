require 'spec_helper'

describe "Static pages" do
  let(:user) { FactoryGirl.create(:user, :client_j)}
  subject { page }

  context "Home Page" do

    it "redirect signed in users to a user specific page" do
      visit_signin_and_login user
      visit root_path
      current_path.should eq dashboard_path(user)
    end

  end

  context "Nav links" do
    before do
      visit root_path
    end

    context "Home Page" do
      it "links to sign up now" do
        click_link "Sign up now!"
        current_path.should eq signup_path
      end

    end

    context "footer" do
      it "links to about" do
        click_link "About"
        current_path.should eq about_path
      end

      it "links to contact" do
        click_link "Contact"
        current_path.should eq contact_path
      end
    end

    context "header" do

      it "links to logo" do
        click_link "logo"
        current_path.should eq root_path
      end
    end


  end

end