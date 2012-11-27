require 'spec_helper'

describe DateAndTime do
  before { Timecop.freeze(Time.zone.parse('1/9/2012 8:00')) }

  context "Initialize" do
    context "with datetime" do
      it "date" do
        DateAndTime.new(datetime: Time.zone.now).date.to_s.should == "2012-09-01"
      end

      it "time" do
        DateAndTime.new(datetime: Time.zone.now).time.to_s.should == "08:00"
      end
    end

    context "with date and time" do
      it "date" do
        args = { date: '1 Sep 2012', time: '08:00'}
        DateAndTime.new(args).date.to_s.should == "2012-09-01"
      end

      it "time" do
        args = { date: '1 Sep 2012', time: '08:00'}
        DateAndTime.new(args).time.to_s.should == "08:00"
      end

    end
  end
end