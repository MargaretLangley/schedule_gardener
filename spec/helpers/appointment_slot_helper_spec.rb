require 'spec_helper'

describe AppointmentSlotHelper do
  it 'length' do
    expect(slot_lengths).to match [['1hrs 30mins', 90], ['3hrs', 180]]
  end
end
