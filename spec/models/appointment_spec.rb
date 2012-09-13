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
		@contact = FactoryGirl.build(:contact, first_name: "Rodger")
		@appointee = FactoryGirl.build(:contact, first_name: "Percy", last_name: "Thrower")
		@event = FactoryGirl.build(:event, :today)
	end

	subject(:appointment) { Appointment.new(contact: @contact, appointee: @appointee, event: @event) }

 	include_examples "All Built Objects", Appointment

 	 # let (:appointment) { FactoryGirl.create(:appointment)}
 	 # it "balh" do
 	 # 	  appointment.should be_valid
 	 # end

  context "Validations" do

	  [ :contact, :appointee, :event ].each do |validate_attr|
			it { should validate_presence_of(validate_attr) }
		end

		[ :contact, :appointee, :event  ].each do |expected_attr|
			it { should respond_to expected_attr }
		end

	end

 	describe "Association" do
 	  it { should belong_to(:contact) }
 	  it { should belong_to(:appointee) }
	  it { should belong_to(:event) }
	end
end
