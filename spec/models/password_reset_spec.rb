require "active_attr/rspec"
#require "app/models/password_reset.rb"
require 'spec_helper'

describe PasswordReset do
  it do
    should have_attribute(:email).
      of_type(String)
  end

  it "emails are validated" do
    should allow_value("user@foo.COM").for(:email)
  end

  it "with bad format are invalid" do
    should_not allow_value("foo@bar_baz.com").for(:email)
  end

  it "with bad format are invalid" do
   should_not allow_value("").for(:email)
  end

end