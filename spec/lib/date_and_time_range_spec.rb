require 'spec_helper'

describe DateAndTime do
  before { Timecop.freeze(Time.zone.parse('1/9/2012 8:00')) }

  context 'Initialize' do
    context 'with datetime' do
      it 'date' do
        expect(DateAndTimeRange.new(start: Time.zone.now, end: Time.zone.now + 1.hours).start.date.to_s).to eq '2012-09-01'
      end

      it 'time' do
        expect(DateAndTimeRange.new(start: Time.zone.now, end: Time.zone.now + 1.hours).start.time.to_s).to eq '08:00'
      end
    end

    context 'with date and time' do
      args = nil
      before do
        args = { start_date: '01 Sep 2012', start_time: '08:00',
                 end_date: '01 Sep 2012', end_time: '10:00'
        }
      end

      it 'start date' do
        expect(DateAndTimeRange.new(args).start.date.to_s).to eq '2012-09-01'
      end

      it 'start time' do
        expect(DateAndTimeRange.new(args).start.time.to_s).to eq '08:00'
      end

      it 'end date' do
        expect(DateAndTimeRange.new(args).end.date.to_s).to eq '2012-09-01'
      end

      it 'end time' do
        expect(DateAndTimeRange.new(args).end.time.to_s).to eq '10:00'
      end
    end

    context 'with date and time and length' do
      args = nil
      before do
        args = { start_date: '01 Sep 2012', start_time: '08:00',
                 length: '60'
        }
      end

      it 'end date' do
        expect(DateAndTimeRange.new(args).end.date.to_s).to eq '2012-09-01'
      end

      it 'end time' do
        expect(DateAndTimeRange.new(args).end.time.to_s).to eq '09:00'
      end
    end

    context '#length' do
      it 'time' do
        expect(DateAndTimeRange.new(start: Time.zone.now, end: Time.zone.now + 1.hours).length).to eq 60
      end
    end
  end
end
