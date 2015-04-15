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
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

class Helper
  def self.create_appointment(contact, start_time, end_time)
    FactoryGirl.create(:appointment, :gardener_a, contact: contact, starts_at: start_time, ends_at: end_time)
  end
end

describe Appointment do
  let!(:contact) { FactoryGirl.create(:contact, :client_r) }
  before { Timecop.freeze(Time.zone.parse('2012-9-1 8:00')) }
  subject(:appointment) do
    FactoryGirl.create(:appointment, :client_r, :gardener_a, :today_first_slot)
  end

  include_examples 'All Built Objects', Appointment

  context 'Validations' do
    [:contact, :appointee].each do |validate_attr|
      it { should validate_presence_of(validate_attr) }
    end
  end

  context 'record for' do
    it '#starts at matches expected time' do
      expect(appointment.starts_at)
        .to eq Time.zone.local(2012, 9, 1, 9, 30)
    end

    it '#ends at matches expected time' do
      expect(appointment.ends_at)
        .to eq Time.zone.local(2012, 9, 1, 11, 0)
    end
  end

  context 'slots' do
    context 'single booking' do
      before do
        e1 = Helper.create_appointment(contact, '01/09/2012 11:30', '01/09/2012 13:00')
        expect(Appointment.all).to eq [e1]
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

  context 'Custom finders' do
    context '#in_time_range' do
      context 'on start boundary' do
        e1 = nil
        before do
          Timecop.travel(Time.zone.parse('2012-8-1 10:00'))
          e1 = Helper.create_appointment(contact, '31/08/2012 22:00', '31/08/2012 23:59')
          expect(Appointment.all).to eq [e1]
        end

        it 'fails' do
          expect(contact.appointments.in_time_range(Time.zone.local(2012, 9, 1)..Time.zone.local(2012, 9, 30, 23, 59))).to eq []
        end
      end

      context 'on start boundary' do
        e1 = nil
        before do
          Timecop.travel(Time.zone.parse('2012-8-1 10:00'))
          e1 = Helper.create_appointment(contact, '31/08/2012 22:00', '01/09/2012 00:00')

          expect(Appointment.all).to eq [e1]
        end

        it 'succeeds' do
          expect(contact.appointments.in_time_range(Time.zone.local(2012, 9, 1)..Time.zone.local(2012, 9, 30, 23, 59))).to eq [e1]
        end
      end

      context 'on end boundary' do
        e1 = e2 = nil
        before do
          e1 = Helper.create_appointment(contact, '30/09/2012 22:00', '30/09/2012 23:59')
          e2 = Helper.create_appointment(contact, '01/10/2012 00:00', '01/10/2012 01:30')

          expect(Appointment.all).to eq [e1, e2]
        end

        it 'succeeds' do
          expect(contact.appointments.in_time_range(Time.zone.local(2012, 9, 1)..Time.zone.local(2012, 9, 30, 23, 59))).to eq [e1]
        end
      end

      context 'across boundary' do
        e1 = e2 = nil
        before do
          Timecop.travel(Time.zone.parse('2012-8-1 10:00'))
          e1 = Helper.create_appointment(contact, '31/08/2012 23:00', '01/09/2012 01:00')
          e2 = Helper.create_appointment(contact, '30/09/2012 22:30', '01/10/2012 01:30')
          Timecop.travel(Time.zone.parse('2012-9-1 10:00'))

          expect(Appointment.all).to eq [e1, e2]
        end
        it 'succeeds' do
          expect(contact.appointments.in_time_range(Time.zone.local(2012, 9, 1)..Time.zone.local(2012, 9, 30, 23, 59))).to eq [e1, e2]
        end
      end

      context "doesn't pick up other contacts appointments" do
        e1 = e2 = nil
        before do
          Timecop.travel(Time.zone.parse('2012-8-1 8:00'))
          e1 = Helper.create_appointment(FactoryGirl.create(:contact, :client_a), '01/09/2012 01:00', '01/09/2012 02:00')
          e2 = Helper.create_appointment(contact, '02/09/2012 01:00', '02/09/2012 02:00')

          expect(Appointment.all).to eq [e1, e2]
        end

        it 'succeeds' do
          expect(contact.appointments.in_time_range(Time.zone.local(2012, 9, 1)..Time.zone.local(2012, 9, 30, 23, 59))).to eq [e2]
        end
      end
    end
  end

  describe 'Association' do
    it { should belong_to(:contact) }
    it { should belong_to(:appointee) }
  end
end
