require 'spec_helper'

describe "event" do
  before { Timecop.freeze(Time.zone.parse('1/9/2012 8:00')) }

  subject { page }

  context "#index" do
    let!(:appointment) do
      FactoryGirl.create(:appointment, :client_r, :gardener_a, :today_first_slot)
    end
    let!(:gardener)  do
      FactoryGirl.create(:user, :gardener)
    end


    before do
      visit_signin_and_login gardener
      visit events_path
    end

    it "should reach events" do
      current_path.should eq events_path
    end

    context "links" do

      it "navigate to appointments path" do
        should have_link('List Appointments', href: appointments_path)
      end
      it "navigate to create appointment path" do
        should have_link('Create Appointment', href: new_appointment_path)
      end
    end
  end
end