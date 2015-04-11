require 'spec_helper'

describe ApplicationHelper do
  context 'application_title_pipe_page_title' do
    it 'should include the page title' do
      application_title_pipe_page_title('foo').should =~ /foo/
    end

    it 'should include the base title' do
      application_title_pipe_page_title('foo').should =~ /^Garden Care/
    end

    it 'should not include a bar for the home page' do
      application_title_pipe_page_title('').should_not =~ /\|/
    end
  end

  context 'view format conversion' do
    context 'minutes -> hrs & mins' do
      it 'Roundable minutes' do
        format_minutes_as_hrs_mins(120).should == '2hrs'
      end
      it 'Unroundable minutes' do
        format_minutes_as_hrs_mins(150).should == '2hrs 30mins'
      end
    end

    context 'phonenumber' do
      it 'outside local area' do
        number_to_phone_without_area_code('0181-100-3003').should eq '0181-100-3003'
      end
      it 'with local area' do
        number_to_phone_without_area_code('0121-333-1234').should eq '333-1234'
      end
    end
  end
end
