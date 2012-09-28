# == Schema Information
#
# Table name: appointments
#
#  id           :integer          not null, primary key
#  contact_id   :integer
#  appointee_id :integer
#  event_id     :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'


describe Appointment do
	before(:all) do
		@contact = FactoryGirl.create(:contact, first_name: "Rodger")
		@appointee = FactoryGirl.create(:contact, first_name: "Percy", last_name: "Thrower")
		@event = FactoryGirl.build(:event, :today)
	end

	after(:all) do
    Contact.delete_all; Address.delete_all; Appointment.delete_all;
	end

	subject(:appointment) do
		                       @appointment = Appointment.new(contact: @contact, appointee_id: @appointee.id)
		                       @appointment.event = @event
                           @appointment
		                    end

 	include_examples "All Built Objects", Appointment


  context "Validations" do

	  [ :contact, :appointee, :event ].each do |validate_attr|
			it { should validate_presence_of(validate_attr) }
		end

		[ :contact, :appointee, :event  ].each do |expected_attr|
			it { should respond_to expected_attr }
		end

	end

	context "#<<" do
		it "<< an appointment" do
    	expect { @contact.appointments << appointment }.to change(@contact.appointments, :count).by(1)
    end
	end

	context "#delete - " do
		before do
		  @contact.appointments << appointment
		end
		it "removes an appointment" do
    	expect { @contact.appointments.delete(appointment) }.to change(@contact.appointments, :count).by(-1)
    end
	end


 	describe "Association" do
 	  it { should belong_to(:contact) }
 	  it { should belong_to(:appointee) }
	  it { should belong_to(:event) }
	end

end
