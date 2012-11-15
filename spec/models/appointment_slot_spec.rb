require 'spec_helper'

describe AppointmentSlot do
  before { Timecop.freeze(Time.zone.parse('1/9/2012 8:00')) }

it "returns full list" do
  AppointmentSlot.all.count == 4
end

context "first" do
  it "has expected time" do
    AppointmentSlot.first.time.should == "09:30"
  end
  it "has expected humanize time" do
    AppointmentSlot.first.humanize_time.should == "Early Morning - (9.30 am)"
  end
  it "has expected value" do
    AppointmentSlot.first.value.should == 570
  end
end

context "#booked_slots" do
  context "single booking" do
    it "include expected" do
      AppointmentSlot.slots_covered_by_time("09:30",90).should eq [1]
    end
  end
  context "double session" do
    it "books both slots" do
      AppointmentSlot.slots_covered_by_time("11:30",210).should eq [2,3]
    end
  end
end

context "time to slot number" do
  it "gives first slot number" do
    AppointmentSlot.start_slot_from_time("09:30").should == 1
  end
  it "gives second slot number" do
    AppointmentSlot.start_slot_from_time("11:30").should == 2
  end
  it "gives third slot number" do
    AppointmentSlot.start_slot_from_time("13:30").should == 3
  end
  it "gives fourth slot number" do
    AppointmentSlot.start_slot_from_time("15:30").should == 4
  end

  it "causes exception" do
    expect { AppointmentSlot.start_slot_from_time("12:00") }.to raise_error(RuntimeError,"Unexpected time: 12:00 in AppointmentSlot.start_slot_from_time")
  end
end

context "slots booked from length" do
  it "returns one slot" do
    AppointmentSlot.duration_to_covered_slots(90).should eq 1
  end
  it "returns one slot" do
    AppointmentSlot.duration_to_covered_slots(210).should eq 2
  end

end


end
