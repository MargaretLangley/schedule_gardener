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

  context "format_phone" do
    it "handles none Brum" do
      format_phone!("01813331234").should =~ /0181-333-1234/
    end

    it "removes brum" do
      format_phone!("01213331234").should =~ /333-1234/
    end

  end

end