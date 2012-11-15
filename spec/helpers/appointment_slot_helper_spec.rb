require 'spec_helper'

describe AppointmentSlotHelper do

  it "length" do
    slot_lengths.should eq [["1hrs 30mins",90],["3hrs",180]]
  end

end