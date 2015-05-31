require 'spec_helper'

describe 'Appointments#index' do
  before(:each) { Timecop.freeze(Time.zone.parse('1/9/2012 5:00')) }
  subject { page }

  context 'standard user' do
    it 'displayed' do
      create_appointment gardener: create_gardener, client: create_client
      visit_signin_and_login create_client
      visit appointments_path

      expect(current_path).to eq appointments_path
    end
    it 'has appointee' do
      create_appointment gardener: create_gardener(name: 'Titmarsh'),
                         client: create_client
      visit_signin_and_login create_client
      visit appointments_path

      should have_selector('td', text: 'Alan Titmarsh')
    end
  end

  context 'gardener' do
    it 'displayed' do
      create_appointment gardener: create_gardener, client: create_client
      visit_signin_and_login create_gardener
      visit appointments_path

      expect(current_path).to eq appointments_path
    end
    it 'displays phone' do
      create_appointment gardener: create_gardener, client: create_client
      visit_signin_and_login create_gardener
      visit appointments_path

      should have_content('0181-100-3003')
    end
  end

  def create_client
    @create_client ||=
      FactoryGirl.create :user, person: FactoryGirl.create(:person, :client_r)
  end

  def create_gardener(name: 'Titmarsh')
    @create_gardener ||=
    FactoryGirl
    .create :user,
            person: FactoryGirl.create(:person, :gardener_a, last_name: name)
  end

  def create_appointment(gardener:, client:)
    FactoryGirl.create(:appointment,
                       :tomorrow_first_slot,
                       appointee: gardener.person,
                       person: client.person)
  end
end
