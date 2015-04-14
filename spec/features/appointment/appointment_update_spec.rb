require 'spec_helper'

describe 'Appointments#update' do
  before(:each) do
    Timecop.freeze(Time.zone.parse('1/9/2012 5:00'))
    visit_signin_and_login user
  end

  let!(:user)         { FactoryGirl.create(:user, :client_r) }
  let!(:gardener_a)   { FactoryGirl.create(:user, :gardener_a) }
  let!(:appointment)  { FactoryGirl.create(:appointment, :tomorrow_first_slot, appointee: gardener_a.contact, contact: user.contact) }

  subject { page }

  it 'displays' do
    visit edit_appointment_path(appointment)
    expect(current_path).to eq edit_appointment_path(appointment)
  end

  context 'with valid information' do
    before do
      visit edit_appointment_path(appointment)
      click_on('Update Appointment')
    end

    context 'on update' do
      it 'displays #update' do
        expect(current_path).to eq appointments_path
      end
      it ('flash success') { should have_flash_success('appointment was successfully updated.') }
    end
  end
end
