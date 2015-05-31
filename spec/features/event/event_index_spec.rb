require 'spec_helper'

describe 'event#index' do
  before { Timecop.freeze(Time.zone.parse('1/9/2012 8:00')) }
  subject { page }

  it 'should reach events' do
    FactoryGirl.create(:appointment, :client_r, :gardener_a, :today_first_slot)

    gardener = FactoryGirl.create(:person, :gardener_a)
    visit_signin_and_login FactoryGirl.create(:user, person: gardener)
    visit events_path

    expect(current_path).to eq events_path
  end
end
