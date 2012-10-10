
require 'spec_helper'

describe "PasswordReset" do
  subject { page }

  before(:all) { @client = FactoryGirl.create(:user, :client) }

  after(:all) { @client.destroy }


  context "#new" do
    before do
      visit new_password_reset_path
    end

    it "should open page" do
      current_path.should eq new_password_reset_path
    end

    context "with valid email" do
      context "in database" do
        before do
          fill_in "email",       with: "john.smith@example.com"
          click_button "Email me password reset instructions"
        end

        it "open password resent" do
          current_path.should eq password_reset_sent_path
        end

        it "Notice set" do
          should have_selector('div.alert.alert-notice', text: 'Email sent with password reset instructions.')
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
            should have_selector('div.alert.alert-notice', text: 'Email sent with password reset instructions.')
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
  end

end
