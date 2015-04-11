require 'spec_helper'

describe ApplicationHelper do
  context 'application_title_pipe_page_title' do
    it 'should include the page title' do
      expect(application_title_pipe_page_title('foo')).to match /foo/
    end

    it 'should include the base title' do
      expect(application_title_pipe_page_title('foo')).to match /^Garden Care/
    end

    it 'should not include a bar for the home page' do
      expect(application_title_pipe_page_title('')).to_not match /\|/
    end
  end

  context 'view format conversion' do
    context 'minutes -> hrs & mins' do
      it 'Roundable minutes' do
        expect(format_minutes_as_hrs_mins(120)).to eq '2hrs'
      end
      it 'Unroundable minutes' do
        expect(format_minutes_as_hrs_mins(150)).to eq '2hrs 30mins'
      end
    end

    context 'phonenumber' do
      it 'outside local area' do
        expect(number_to_phone_without_area_code('0181-100-3003')).to eq '0181-100-3003'
      end
      it 'with local area' do
        expect(number_to_phone_without_area_code('0121-333-1234')).to eq '333-1234'
      end
    end
  end
end
