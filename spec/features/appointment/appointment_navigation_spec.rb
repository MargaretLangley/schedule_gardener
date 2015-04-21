require 'spec_helper'

describe 'Appointments navigation' do
  before(:each) do
    Timecop.freeze(Time.zone.parse('1/9/2012 5:00'))
  end

  let!(:user) do
    FactoryGirl.create(:user, contact: FactoryGirl.create(:contact, :client_r))
  end
  let!(:gardener_a)   { FactoryGirl.create(:user, :gardener_a) }
  let!(:appointment)  { FactoryGirl.create(:appointment, :tomorrow_first_slot, appointee: gardener_a.contact, contact: user.contact) }

  subject { page }

  describe '#index' do
    context 'standard user' do
      before(:each) do
        visit_signin_and_login user
        visit appointments_path
      end

      context 'nav links' do
        it ('not displayed') { should_not have_link('This Week') }
      end

      it 'edits appointment' do
        click_on('Edit')
        expect(current_path).to eq edit_appointment_path(appointment)
      end
      it ('deletes appointment') { expect { click_on('Delete') }.to change(Appointment, :count).by(-1) }
    end

    context 'gardener' do
      before(:each) do
        (FactoryGirl.create(:appointment, :next_week_first_slot, :client_a, appointee: gardener_a.contact)).save!
        visit_signin_and_login gardener_a
        visit appointments_path
      end

      context 'nav links' do
        context 'this week' do
          before { click_on('This Week') }
          it ('displays appointee') { should have_selector('td', text: 'Roger') }
          it ('not displays next week') { should_not have_selector('td', text: 'Ann') }
        end

        context 'next week' do
          before { click_on('Next Week') }
          it ('displays appointee') { should have_selector('td', text: 'Ann') }
          it ('not displays last week') { should_not have_selector('td', text: 'Roger') }
        end
      end

      it 'shows calendar' do
        click_on('Calendar')
        expect(current_path).to eq events_path
      end
    end
  end

  describe '#create' do
    it 'can cancel' do
      visit_signin_and_login user
      visit new_appointment_path
      click_on('Cancel')

      expect(current_path).to eq appointments_path
    end
  end
end
