# == Schema Information
#
# Table name: appointments
#
#  id           :integer          not null, primary key
#  contact_id   :integer
#  appointee_id :integer
#  title        :string(255)      not null
#  starts_at    :datetime         not null
#  ends_at      :datetime
#  all_day      :boolean          default(FALSE)
#  description  :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#


require 'spec_helper'


describe Appointment do
	 before(:all) do
	 	@contact = FactoryGirl.create(:contact, :client_r)
	 end

	 after(:all) do
     Contact.delete_all; Address.delete_all;
	 end

	subject(:appointment) { FactoryGirl.create(:appointment, :gardener_a, :tomorrow, contact: @contact)}

 	include_examples "All Built Objects", Appointment

  context "Accessable" do

		[:created_at, :updated_at].each do |validate_attr|
			it { should_not allow_mass_assignment_of(validate_attr) }
		end

	  [:appointee,:all_day, :contact,:description, :ends_at, :starts_at, :title ].each do |expected_attr|
			it { should respond_to expected_attr }
		end
	end


  context "Validations" do

	  [:contact, :appointee, :starts_at, :title].each do |validate_attr|
			it { should validate_presence_of(validate_attr) }
		end

		[:title ].each do |validate_attr|
			it { should ensure_length_of(validate_attr).is_at_most(50) }
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


	context "Custom finders" do

    context "#after_now" do

      context "before boundary" do
        e1 = e2 = e3 = e4 = nil
        before do
          puts Time.now.utc
          e1 = FactoryGirl.create(:appointment, :gardener_a, contact:  @contact, title: "e1 just before boundary", starts_at: Time.now.utc.advance(minutes: -10))
          e2 = FactoryGirl.create(:appointment, :gardener_a, contact:  @contact, title: "e2 just after boundary",  starts_at: Time.now.utc.advance(minutes: 5))
          e3 = FactoryGirl.create(:appointment, :gardener_a, contact:  @contact, title: "e3 well after_boundary",  starts_at: Time.now.utc.end_of_month)
          Appointment.all.should eq [e1, e2, e3]
        end

        it "are not included" do
          @contact.appointments.after_now().should eq [e2,e3]
        end
      end
    end

	  context "#in_time_range" do

	 		context "on boundary" do
	 		  e1 = e2 = e3 = e4 = nil
	 		  before do
		 			e1 = FactoryGirl.create(:appointment, :gardener_a, contact: 	@contact, title: "e1_on_boundary", starts_at: Time.now.utc.beginning_of_month.advance(hours: -4))
		 			e2 = FactoryGirl.create(:appointment, :gardener_a, contact: 	@contact, title: "e2_on_boundary", starts_at: Time.now.utc.beginning_of_month.advance(hours: 1))
		 			e3 = FactoryGirl.create(:appointment, :gardener_a, contact: 	@contact, title: "e3_on_boundary", starts_at: Time.now.utc.end_of_month.advance(hours: -4))
		 			e4 = FactoryGirl.create(:appointment, :gardener_a, contact: 	@contact, title: "e4_on_boundary", starts_at: Time.now.utc.end_of_month.advance(hours: 4))
		 			Appointment.all.should eq [e1, e2,e3,e4]
		 		end

		    it "suceeds" do
			    @contact.appointments.in_time_range(Time.now.utc.beginning_of_month..
			    	                 			Time.now.utc.end_of_month,
			    	                 			).should eq [e2,e3]
		    end
		  end

		  context "accross boundary" do
			  e1 = e2 = nil
	 		  before do
	 		  	e1 = FactoryGirl.create(:appointment, :gardener_a, contact: 	@contact, title: "e1_accross_boundary", starts_at: Time.now.utc.beginning_of_month.advance(hours: -2))
	 			  e2 = FactoryGirl.create(:appointment, :gardener_a, contact: 	@contact, title: "e2_accross_boundary", starts_at: Time.now.utc.end_of_month.advance(hours: - 1))
		 			Appointment.all.should eq [e1, e2]
		 		end

		    it "suceeds" do
			    @contact.appointments.in_time_range(Time.now.utc.beginning_of_month..
			    	                 		 Time.now.utc.end_of_month,
			    	                 		 ).should eq [e1,e2]
		    end
      end

		  context "nil end" do
			  e1 = e2 = nil
	 		  before do
	 		  	e1 = FactoryGirl.create(:appointment, :gardener_a, contact: 	@contact, title: "e1_nil_end", ends_at: nil, starts_at: Time.now.utc.beginning_of_month.advance(hours: + 10))
		 			Appointment.all.should eq [e1]
		 		end

		    it "suceeds" do
			    appointments = @contact.appointments
			    appointments.in_time_range(Time.now.utc.beginning_of_month..
			    	              	  	 Time.now.utc.end_of_month,
			    	                	 	 ).should eq [e1]
		    end
      end

      context "doesn't pick up other contacts appointments" do
        e1 = e2 = nil
        before do
        	e1 = FactoryGirl.create(:appointment, :gardener_a, :client, title: "e2_on_boundary", starts_at: Time.now.utc.beginning_of_month.advance(hours: 1))
		 			e2 = FactoryGirl.create(:appointment, :gardener_a, contact: 	@contact, title: "e3_on_boundary", starts_at: Time.now.utc.end_of_month.advance(hours: -4))
        	Appointment.all.should eq [e1,e2]
        end

		    it "suceeds" do
			    @contact.appointments.in_time_range(Time.now.utc.beginning_of_month..
			    	                 			Time.now.utc.end_of_month,
			    	                 			).should eq [e2]
		    end


      end

    end

	end

	describe "to_event" do
    let(:event) { appointment.to_event }
    it "title output" do
			event.title.should eq "created by appointment tomorrow"
    end

    it "can serialize" do
    	event = Event.new()
    	event.attributes = {"title"=>"Weeding", "starts_at"=>"Mon Oct 22 2012 00:00:00 GMT+0100 (BST)", "description"=>" aj "}
			event.should be_valid
    end
	end



 	describe "Association" do
 	  it { should belong_to(:contact) }
 	  it { should belong_to(:appointee) }
	end

end
