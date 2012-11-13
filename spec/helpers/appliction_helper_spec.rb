require 'spec_helper'

describe ApplicationHelper do

  context "application_title_pipe_page_title" do
    it "should include the page title" do
      application_title_pipe_page_title("foo").should =~ /foo/
    end

    it "should include the base title" do
      application_title_pipe_page_title("foo").should =~ /^Garden Care/
    end

    it "should not include a bar for the home page" do
      application_title_pipe_page_title("").should_not =~ /\|/
    end
  end

  context "number to phone without area code" do
    it "none local" do
      number_to_phone_without_area_code("0181-100-3003").should eq "0181-100-3003"
    end
    it "local" do
      number_to_phone_without_area_code("0121-333-1234").should eq "333-1234"
    end
  end

end