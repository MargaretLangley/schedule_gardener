require 'spec_helper'

describe 'Appointments#create' do
  subject { page }

  context 'standard user' do
    let!(:user) do
      FactoryGirl.create(:user, contact: FactoryGirl.create(:contact, :client_r))
    end
    let!(:gardener_alan) do
      gardener = FactoryGirl.create(:contact, :gardener_a)
      FactoryGirl.create(:user, contact: gardener)
    end
    before(:each) do
      Timecop.freeze(Time.zone.parse('1/9/2012 5:00'))
      visit_signin_and_login user
      visit new_appointment_path
    end

    it 'displayed' do
      expect(current_path).to eq new_appointment_path
    end
    it 'keeps client choice confidential' do
      should_not have_content('Client')
    end

    context 'with valid information' do
      it 'adds appointment' do
        select 'Alan', from: 'Gardener'

        expect { click_on('Create Appointment') }
          .to change(Appointment, :count).by(1)
      end

      describe 'success' do
        it 'navigates to index' do
          select 'Alan', from: 'Gardener'
          click_on('Create Appointment')

          expect(current_path).to eq appointments_path
        end

        it 'flashes success' do
          select 'Alan', from: 'Gardener'
          click_on('Create Appointment')

          should have_flash_success ('appointment was successfully created.')
        end
      end
    end
  end

  context 'gardener' do
    let!(:user) do
      FactoryGirl.create(:user, contact: FactoryGirl.create(:contact, :client_r))
    end
    let!(:gardener_alan) do
      gardener = FactoryGirl.create(:contact, :gardener_a)
      FactoryGirl.create(:user, contact: gardener)
    end

    before do
      Timecop.freeze(Time.zone.parse('1/9/2012 5:00'))
      visit_signin_and_login gardener_alan
      visit new_appointment_path
    end

    it 'displayed' do
      expect(current_path).to eq new_appointment_path
    end
    it ('has client') { should have_content('Client') }

    context 'with valid information' do
      before do
        select 'Alan', from: 'Gardener'
        select 'Roger', from: 'Client'
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
