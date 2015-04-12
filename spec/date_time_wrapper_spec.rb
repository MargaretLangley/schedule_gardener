require 'spec_helper'
require_relative '../lib/date_time_wrapper'

describe DateTimeWrapper do
  before { Timecop.freeze(Time.zone.parse('1/9/2012 8:00')) }

  context 'Initialize' do
    it 'handles datetime' do
      expect(DateTimeWrapper.new(datetime: Time.zone.now).datetime)
        .to eq Time.zone.local(2012, 9, 1, 8, 0)
    end

    it 'handles date and time' do
      args = { date: '1 Sep 2012', time: '08:00' }
      expect(DateTimeWrapper.new(args).datetime)
        .to eq Time.zone.local(2012, 9, 1, 8, 0)
    end

    describe 'accessors' do
      it 'date' do
        expect(DateTimeWrapper.new(datetime: Time.zone.now).date.to_s).to eq '2012-09-01'
      end

      it 'time' do
        expect(DateTimeWrapper.new(datetime: Time.zone.now).time.to_s).to eq '08:00'
      end
    end
  end
end
