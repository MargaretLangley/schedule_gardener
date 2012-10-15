
require 'spec_helper'

describe "PasswordReset" do
  subject { page }

  before(:all) { @client = FactoryGirl.create(:user, :client, :resetting_password) }
  after(:all) { @client.destroy }


  context "#new" do
    before do
      visit new_password_reset_path
    end

    it "should open page" do
      current_path.should eq new_password_reset_path
    end

    context "with valid email" do
      before do
        FactoryGirl.create(:user, :email_tester)
      end
      context "in database" do
        before do
          fill_in "email",       with: "richard.wigley@gmail.com"
          click_button "Email me password reset instructions"
        end

        it "open password resent" do
          current_path.should eq password_reset_sent_path
        end

        xit "Notice set" do
          should have_flash_notice('Email sent with password reset instructions.')
        end

      end

      context "absent from database" do

        context "after submits" do
          before do
            fill_in "email",       with: "unknown.user@example.com"
            click_button "Email me password reset instructions"
          end

          it "open password resent" do
            current_path.should eq password_reset_sent_path
          end

          it "Notice set" do
            should have_flash_notice('Email sent with password reset instructions.')
          end
        end
      end
    end

    context "when enter invalid email" do
      before do
        fill_in "password_reset_email",       with: "email@example,com"
        click_button "Email me password reset instructions"
      end

      it "waits on the create action" do
        current_path.should eq password_resets_path
      end

      it "has error banner" do
        should have_content('error')
      end
    end

  end

  context "#edit" do
    before do
      visit edit_password_reset_path( @client.password_reset_token)
    end
    context "within time" do
      it "opens page" do
        current_path.should eq edit_password_reset_path(@client.password_reset_token)
      end
      context "good input" do
        before do
          fill_in "Password", with: "password"
          fill_in "Confirm password", with: "password"
          click_button "Update Password"
        end
        it "matching passwords succeed" do
          current_path.should eq root_path
        end
        it "should display notice" do
          should have_flash_notice("Password has been reset")
        end
      end
      context "bad input" do
        before do
          fill_in "Password", with: "password"
          fill_in "Confirm password", with: "wrong"
          click_button "Update Password"
        end
        it "has error banner" do
          should have_content('error')
        end
      end
    end
    context "out of time" do
      let!(:client_expired) { FactoryGirl.create(:user, :client, :expired_reset_password) }
      before do
        visit edit_password_reset_path(client_expired.password_reset_token)
      end

      it "opens new reset page" do
        current_path.should eq new_password_reset_path
      end

      it "has flash error" do
        should have_flash_error("Password reset has expired.")
      end
    end
  end

end

