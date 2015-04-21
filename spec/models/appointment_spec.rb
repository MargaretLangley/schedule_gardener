# == Schema Information
#
# Table name: appointments
#
#  id           :integer          not null, primary key
#  contact_id   :integer
#  appointee_id :integer
#  starts_at    :datetime         not null
#  ends_at      :datetime         not null
#  description  :text
#  created_at   :datetime
#  updated_at   :datetime
#

require 'spec_helper'

describe Appointment do
  before { Timecop.freeze(Time.zone.parse('2012-9-1 8:00')) }

  def create_appointment(contact: FactoryGirl.create(:contact, :client_r),
                         appointee: FactoryGirl.create(:contact, :gardener_a),
                         starts_at:, ends_at:)

    Appointment.create!(contact: contact, appointee: appointee, starts_at: starts_at, ends_at: ends_at)
  end

  describe 'slots' do
    context 'single booking' do
      before do
        a1 = create_appointment(starts_at: '01/09/2012 11:30', ends_at: '01/09/2012 13:00')
        expect(Appointment.all).to eq [a1]
      end
      it 'exclude slots before' do
        expect(Appointment.first.include_slot_number?(1)).to be false
      end
      it 'include slot during' do
        expect(Appointment.first.include_slot_number?(2)).to be true
      end
      it 'exclude slots after' do
        expect(Appointment.first.include_slot_number?(3)).to be false
      end
    end
  end

  describe 'Custom finders' do
    describe '#in_time_range' do
      describe 'start boundary' do
        it 'misses appointments that end before the start boundary' do
          Timecop.travel Time.zone.parse('2012-8-1 10:00')
          create_appointment starts_at: '31/08/2012 22:00',
                             ends_at: '31/08/2012 23:59'

          expect(Appointment.in_time_range(Time.zone.local(2012, 9, 1)..
                                           Time.zone.local(2012, 9, 30, 23, 59)))
            .to eq []
        end

        it 'finds appointments that end after the start boundary' do
          Timecop.travel(Time.zone.parse('2012-8-1 10:00'))
          a1 = create_appointment(starts_at: '31/08/2012 22:00',
                                  ends_at: '01/09/2012 00:00')

          expect(Appointment.in_time_range(Time.zone.local(2012, 9, 1)..
                                           Time.zone.local(2012, 9, 30, 23, 59)))
            .to eq [a1]
        end
      end

      describe 'end boundary' do
        it 'finds appointments that start before the end boundary' do
          a1 = create_appointment(starts_at: '30/09/2012 22:00',
                                  ends_at: '01/10/2012 01:30')

          expect(Appointment.in_time_range(Time.zone.local(2012, 9, 1)..
                                           Time.zone.local(2012, 9, 30, 23, 59)))
            .to eq [a1]
        end

        it 'misses appointments that start after the end boundary' do
          create_appointment(starts_at: '01/10/2012 00:00',
                             ends_at: '01/10/2012 01:30')
          expect(Appointment.in_time_range(Time.zone.local(2012, 9, 1)..
                                           Time.zone.local(2012, 9, 30, 23, 59)))
            .to eq []
        end
      end
    end
  end
end
