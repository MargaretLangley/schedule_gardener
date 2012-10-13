require 'spec_helper'

describe PasswordResetsController do

  before(:all) { @client = FactoryGirl.create(:user, :client_a) }
  after(:all)  { @client.destroy }

  describe "#create" do

    # getting smtp error in test but works in dev (ERR CONN 2)
    xit "should receive an known email to send" do
      mail = FactoryGirl.build(:message)
      UserMailer.should_receive(:password_reset).with(@client).and_return(mail)
      post :create, password_reset: { email: "john.smith@example.com"}
    end

    it "should not receive an unknown email to send" do
      UserMailer.should_not_receive(:password_reset)
      post :create, password_reset: { email: "unknown.user@example.com"}
    end

    it "should deliver the signup email" do
      Rails.logger.should_receive(:info).with("unknown email requested for password reset: unknown.user@example.com")
      post :create, password_reset: { email: "unknown.user@example.com"}
    end
  end

  describe "#update" do
    it "should redirect a put with an expired token" do
      client_with_expired_token = FactoryGirl.create(:user, :client_a, :expired_reset_password)
      post :update, id: client_with_expired_token.password_reset_token
      response.should redirect_to new_password_reset_path
    end
  end
end