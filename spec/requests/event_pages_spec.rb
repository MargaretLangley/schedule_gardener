require 'spec_helper'

describe "event" do

  subject { page }

  context "#index" do
    let!(:admin)  do
      FactoryGirl.create(:user, :admin)
    end

    before do
      visit_signin_and_login admin
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