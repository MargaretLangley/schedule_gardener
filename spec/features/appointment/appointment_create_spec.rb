require 'spec_helper'

describe 'Appointments#create' do
  let!(:user)         { FactoryGirl.create(:user, :client_r) }
  let!(:gardener_alan) { FactoryGirl.create(:user, :gardener_a) }

  subject { page }

  context 'standard user' do
    before(:each) do
      Timecop.freeze(Time.zone.parse('1/9/2012 5:00'))
      visit_signin_and_login user
      visit new_appointment_path
    end

    it 'displayed' do
      expect(current_path).to eq new_appointment_path
    end
    it ('has client missing') { should_not have_selector('#appointment_contact_id') }

    context 'with valid information' do
      it 'adds appointment' do
        select 'Alan', from: 'appointment_appointee_id'

        expect { click_on('Create Appointment') }
          .to change(Appointment, :count).by(1)
      end

      describe 'success' do
        it 'navigates to index' do
          select 'Alan', from: 'appointment_appointee_id'
          click_on('Create Appointment')

          expect(current_path).to eq appointments_path
        end

        it 'flashes success' do
          select 'Alan', from: 'appointment_appointee_id'
          click_on('Create Appointment')

          should have_flash_success ('appointment was successfully created.')
        end
      end
    end
  end

  context 'gardener' do
    before do
      Timecop.freeze(Time.zone.parse('1/9/2012 5:00'))
      visit_signin_and_login gardener_alan
      visit new_appointment_path
    end

    it 'displayed' do
      expect(current_path).to eq new_appointment_path
    end
    it ('has client') { should have_selector('#appointment_contact_id', visible: true) }

    context 'with valid information' do
      before do
        select 'Alan', from: 'appointment_appointee_id'
        select 'Roger', from: 'appointment_contact_id'
      end

      it ('adds appointment') { expect { click_on('Create Appointment') }.to change(Appointment, :count).by(1) }
    end
  end

  context 'admin' do
    it 'displays' do
      visit_signin_and_login FactoryGirl.create(:user, :admin)
      visit new_appointment_path

      expect(current_path).to eq new_appointment_path
    end
  end
end
