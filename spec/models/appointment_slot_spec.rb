# == Schema Information
#
# Table name: appointment_slots
#
#  id            :integer          not null, primary key
#  time          :string(255)      not null
#  humanize_time :string(255)      not null
#  value         :integer          not null
#  created_at    :datetime
#  updated_at    :datetime
#

require 'spec_helper'

describe AppointmentSlot do
  before { Timecop.freeze(Time.zone.parse('1/9/2012 8:00')) }

  it 'returns full list' do
    AppointmentSlot.all.count == 4
  end

  context 'first' do
    it 'has expected time' do
      expect(AppointmentSlot.first.time).to eq '09:30'
    end
    it 'has expected humanize time' do
      expect(AppointmentSlot.first.humanize_time).to eq 'Early Morning - (9.30 am)'
    end
    it 'has expected value' do
      expect(AppointmentSlot.first.value).to eq 570
    end
  end

  context '#booked_slots' do
    context 'single booking' do
      it 'include expected' do
        expect(AppointmentSlot.slots_in_time_range(Time.zone.parse('2012/09/01 09:30')..Time.zone.parse('2012/09/01 11:00'))).to eq [1]
      end
    end
    context 'double session' do
      it 'books both slots' do
        expect(AppointmentSlot.slots_in_time_range(
                 (Time.zone.parse('2012/09/01 11:30')..Time.zone.parse('2012/09/01 14:30'))
        )).to eq [2, 3]
      end
    end
  end

  context 'time to slot number' do
    it 'gives first slot number' do
      expect(AppointmentSlot.start_slot_from_time(Time.zone.parse('2012/09/01 09:30'))).to eq 1
    end
    it 'gives second slot number' do
      expect(AppointmentSlot.start_slot_from_time(Time.zone.parse('2012/09/01 11:30'))).to eq 2
    end
    it 'gives third slot number' do
      expect(AppointmentSlot.start_slot_from_time(Time.zone.parse('2012/09/01 13:30'))).to eq 3
    end
    it 'gives fourth slot number' do
      expect(AppointmentSlot.start_slot_from_time(Time.zone.parse('2012/09/01 15:30'))).to eq 4
    end

    it 'causes exception' do
      expect { AppointmentSlot.start_slot_from_time(Time.zone.parse('2012/09/01 12:00')) }.to raise_error(RuntimeError, 'Unexpected time: 12:00 in AppointmentSlot.start_slot_from_time')
    end
  end
end
