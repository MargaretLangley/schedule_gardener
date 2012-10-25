# == Schema Information
#
# Table name: appointments
#
#  id           :integer          not null, primary key
#  contact_id   :integer
#  appointee_id :integer
#  starts_at    :datetime         not null
#  ends_at      :datetime         not null
#  description  :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

class Helper
  def self.create_appointment(contact, start_time, end_time)
    (app = FactoryGirl.build(:appointment, :gardener_a, contact: contact, starts_at: start_time, ends_at: end_time)).save!
    app
  end
end

describe Appointment do
  before(:all) { @contact = FactoryGirl.create(:contact, :client_r) }
  before { Timecop.freeze(Time.zone.parse('1/9/2012 8:00')) }

  after(:all) { Contact.delete_all; Address.delete_all; }

  subject(:appointment) do
    (app = FactoryGirl.build(:appointment, :client, :gardener_a, :today_first_slot)).save!
    app
  end

  include_examples "All Built Objects", Appointment


  context "Time Zones" do
    it "expected" do
      Time.zone.to_s.should == '(GMT+00:00) London'
    end
    it "time correct" do
      Time.zone.now.should == "Sat, 01 Sep 2012 08:00:00 BST +01:00"
    end
  end

  context "Accessable" do

    [:created_at, :updated_at].each do |validate_attr|
      it { should_not allow_mass_assignment_of(validate_attr) }
    end

    [:appointee, :contact,:description, :ends_at, :starts_at, :title ].each do |expected_attr|
      it { should respond_to expected_attr }
    end
  end


  context "Validations" do

    [:contact, :appointee ].each do |validate_attr|
      it { should validate_presence_of(validate_attr) }
    end

  end

  context "new record" do
    subject(:new_appointment) do
      Appointment.new(contact: @contact, appointee: FactoryGirl.create(:contact, :gardener_a))
    end

    context "starts_at" do

      it ("has") { new_appointment.starts_at.should eq "Sun, 02 Sep 2012 00:00:00 BST +01:00" }
      it ("date: today") { new_appointment.starts_at_date.should eq "02 Sep 2012" }
      it ("time: beginning of day")  { new_appointment.starts_at_time.should eq "00:00" }

      context "after setting accessors and validating" do

        before do
          new_appointment.starts_at_date = "02 Sep 2012"
          new_appointment.starts_at_time = "9:30"
          new_appointment.valid?
        end

        it "have no errors" do
          new_appointment.errors[:starts_at].should be_empty
        end

        it "changed time" do
          new_appointment.starts_at.should eq "Sun, 02 Sep 2012 09:30:00 BST +00:00"
        end

        it "expected date accessor" do
          new_appointment.starts_at_date.should == "02 Sep 2012"
        end

        it "expected time accessor" do
          new_appointment.starts_at_time.should == "9:30"
        end

        it "start eq end" do
          new_appointment.ends_at.should eq "Sun, 02 Sep 2012 09:30:00 BST +01:00"
        end
        context "Conversion" do
          it "converts into local string time" do
            new_appointment.starts_at_date.should == "02 Sep 2012"
          end

          it "converts into local string time" do
            new_appointment.starts_at_time.should == "9:30"
          end
        end
        context "after save" do
          before do
            appointment = Appointment.last
          end
          it "should have expected starts_at" do
            appointment.starts_at.should == "Sun, 02 Sep 2012 09:30:00 BST +01:00"
          end
        end

      end
    end

    context "end at" do

      it ("date: beginning of today") { appointment.ends_at.should eq "02 Sep 2012 00:00:00 BST +01:00" }
      it "length of 0"  do
         appointment.length_of_appointment.should == 0
       end

      it "as exptected" do
        appointment.length_of_appointment = 180
        appointment.valid?
        appointment.ends_at.should eq "Sun, 02 Sep 2012 03:00:00 BST +01:00"
      end

      it "invalid" do
        appointment.length_of_appointment = -60
        appointment.valid?
        appointment.errors[:ends_at].should include("The appointment can not finish before it begins.")
      end

    end
  end

  context "Created Record" do
    context "Starts at" do
      it "matches expected time" do
        appointment.starts_at.should eq "Sat, 2012-09-01 08:30:00 UTC +00:00"
      end
      it "access matches expected date" do
        appointment.starts_at_date.should eq "01 Sep 2012"
      end
      it "access matches expected local time" do
        appointment.starts_at_time.should eq "09:30"
      end
    end

    context "Ends at" do
      it "matches expected time" do
        appointment.ends_at.should eq "Sat, 01 Sep 2012 10:00:00 UTC +00:00"
      end
    end
  end

	context "Custom finders" do

    context "#after_now" do

      context "before boundary" do
        e1 = e2 = nil
        before do
          e1 = Helper.create_appointment(@contact, '01/09/2012 08:30', '01/09/2012 10:00')
          e2 = Helper.create_appointment(@contact, '01/09/2012 10:30','01/09/2012 11:00')
          Appointment.all.should eq [e1, e2]
        end

        it "are not included" do
          Timecop.travel(Time.zone.parse('1/9/2012 10:00'))
          @contact.appointments.after_now().should eq [e2]
        end
      end
    end

	  context "#in_time_range" do

	 		context "on start boundary" do
	 		  e1 = nil
	 		  before do
          Timecop.travel(Time.zone.parse('1/8/2012 10:00'))
          e1 = Helper.create_appointment(@contact, '31/08/2012 22:00', '31/08/2012 23:59')
		 			Appointment.all.should eq [e1]
		 		end

		    it "fails" do
			    @contact.appointments.in_time_range('2012/09/01 00:00'..'2012/09/30 23:59').should eq []
		    end
		  end

      context "on start boundary" do
        e1 = nil
        before do
          Timecop.travel(Time.zone.parse('1/8/2012 10:00'))
          e1 = Helper.create_appointment(@contact, '31/08/2012 22:00', '01/09/2012 00:00')
          Appointment.all.should eq [e1]
        end

        it "suceeds" do
          @contact.appointments.in_time_range(Time.zone.parse('2012/09/01 00:00')..Time.zone.parse('2012/09/30 23:59')).should eq  [e1]
        end
      end


      context "on end boundary" do
        e1 = e2 = nil
        before do
          e1 = Helper.create_appointment(@contact, '30/09/2012 22:00', '30/09/2012 23:59')
          e2 = Helper.create_appointment(@contact, '01/10/2012 00:00', '01/10/2012 01:30')
          Appointment.all.should eq [e1, e2]
        end

        it "suceeds" do
          @contact.appointments.in_time_range(Time.zone.parse('2012/09/01 00:00')..Time.zone.parse('2012/09/30 23:59')).should eq [e1]
        end
      end


		  context "accross boundary" do
			  e1 = e2 = nil
	 		  before do
          Timecop.travel(Time.zone.parse('1/8/2012 10:00'))
          e1 = Helper.create_appointment(@contact, '31/08/2012 23:00', '01/09/2012 01:00')
          e2 = Helper.create_appointment(@contact, '30/09/2012 22:30', '01/10/2012 01:30')
          Timecop.travel(Time.zone.parse('1/9/2012 10:00'))
		 			Appointment.all.should eq [e1, e2]
		 		end

		    it "suceeds" do
			    @contact.appointments.in_time_range(Time.zone.parse('2012/09/01 00:00')..Time.zone.parse('2012/09/30 23:59')).should eq [e1,e2]
		    end
      end

      context "doesn't pick up other contacts appointments" do
        e1 = e2 = nil
        before do
          Timecop.travel(Time.zone.parse('1/8/2012 08:00'))
          e1 = Helper.create_appointment(FactoryGirl.create(:contact , :client_a), '01/09/2012 01:00', '01/09/2012 02:00')
          e2 = Helper.create_appointment(@contact, '02/09/2012 01:00', '02/09/2012 02:00')
        	Appointment.all.should eq [e1,e2]
        end

		    it "suceeds" do
			    @contact.appointments.in_time_range(Time.zone.parse('2012/09/01 00:00')..Time.zone.parse('2012/09/30 23:59')).should eq [e2]
		    end

      end

    end

	end

 	describe "Association" do
 	  it { should belong_to(:contact) }
 	  it { should belong_to(:appointee) }
	end

end
