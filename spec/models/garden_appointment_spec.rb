require 'spec_helper'

describe GardenAppointment do
	before(:all) do
		@gardener = FactoryGirl.create(:contact, first_name: "Percy", last_name: "Thrower")
		@payee = FactoryGirl.create(:contact, first_name: "Rodger")
		@event = FactoryGirl.create(:event)
	end

 # gardener = FactoryGirl.create(:contact, first_name: "Percy", last_name: "Thrower")
 # gardener.garden_appointments << GardenAppointment.new()
 # gardener.save



 # ga = GardenAppointment.new(gardener: gardener, payee: payee, garden: payee.gardens.first,event: event)

 # delete from addresses;
 # delete from contacts;
 # delete from users;
 # delete from events;
 # delete from gardens;
 # delete from garden_appointments;


    
	# subject(:garden_appointment) { GardenAppointment.new(gardener: @gardener, payee: @payee, garden: @payee.gardens.first,event: @event) }

 #  it "be valid" do
 #  	puts "***" + garden_appointment.valid 
 #  	should be_valid
 #  end
	

# 	include_examples "All Built Objects", GardenAppointment

#   context "Validations" do

# 	  [ :gardener, :payee, :garden, :event ].each do |validate_attr|
# 			it { should validate_presence_of(validate_attr) }
# 		end

# 		[ :gardener, :payee, :garden, :event  ].each do |expected_attr|
# 			it { should respond_to expected_attr }
# 		end

# 	end


#  	describe "Association" do
#  	  it { should belong_to(:gardener) }
#  	  it { should belong_to(:payee) }
# 	  it { should belong_to(:garden) }
# 	  it { should belong_to(:event) }
# 	end
end
