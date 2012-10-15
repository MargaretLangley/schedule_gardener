require "spec_helper"

describe UserMailer do

  describe "password_reset" do
    let!(:mail) { UserMailer.password_reset(FactoryGirl.create(:user, :client, :resetting_password)) }


    it "renders the headers" do
      mail.subject.should eq("Password Reset")
    end


    it "sent to" do
      mail.to.should eq(["john.smith@example.com"])
    end

    it "sent from" do
      mail.from.should eq(["mail@suton.gardencare.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("To reset your password")
    end
  end

end
