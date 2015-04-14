require 'spec_helper'

describe 'Appointments#index' do
  before(:each) do
    Timecop.freeze(Time.zone.parse('1/9/2012 5:00'))
  end

  let!(:user)         { FactoryGirl.create(:user, :client_r) }
  let!(:gardener_a)   { FactoryGirl.create(:user, :gardener_a) }
  let!(:appointment)  { FactoryGirl.create(:appointment, :tomorrow_first_slot, appointee: gardener_a.contact, contact: user.contact) }

  subject { page }

  context 'standard user' do
    before(:each) do
      visit_signin_and_login user
      visit appointments_path
    end

    it 'displayed' do
      expect(current_path).to eq appointments_path
    end
    it ('has appointee') { should have_selector('td', text: 'Alan Titmarsh') }
  end

  context 'gardener' do
    before(:each) do
      (FactoryGirl.create(:appointment, :next_week_first_slot, :client_a, appointee: gardener_a.contact)).save!
      visit_signin_and_login gardener_a
      visit appointments_path
    end

    it 'displayed' do
      expect(current_path).to eq appointments_path
    end
    it ('displays phone') { should have_content('0181-100-3003') }
  end
end
