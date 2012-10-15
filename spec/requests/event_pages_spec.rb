require 'spec_helper'

describe "event" do

  subject { page }

  context "#index" do
    let!(:appointment) do
      FactoryGirl.create(:appointment, :client, :gardener_a, :tomorrow, title: "weeding")
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

      it "should have appointment link" do
        should have_link('weeding', href: edit_appointment_path(appointment))
      end

      it "navigate to appointments path" do
        should have_link('List Appointments', href: appointments_path)
      end
      it "navigate to create appointment path" do
        should have_link('Create Appointment', href: new_appointment_path)
      end
    end
  end
end