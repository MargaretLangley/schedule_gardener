# == Schema Information
#
# Table name: contacts
#
#  id               :integer          not null, primary key
#  contactable_id   :integer
#  contactable_type :string(255)
#  first_name       :string(255)      not null
#  last_name        :string(255)
#  email            :string(255)
#  home_phone       :string(255)      not null
#  mobile           :string(255)
#  role             :string(255)      not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#


require 'spec_helper'

describe Contact do
  before { Timecop.freeze(Time.zone.parse('1/9/2012 8:00')) }
	subject(:contact) { FactoryGirl.build(:contact, :client_r) }

	include_examples "All Built Objects", Contact

	it "has a valid factory" do
    FactoryGirl.create(:contact, :client_r).should be_valid
  end

	context "Accessable" do

		[ :contactable_id, :contactable_type].each do |validate_attr|
			it { should_not allow_mass_assignment_of(validate_attr) }
		end

	 [:address, :email, :first_name, :full_name,:home_phone, :last_name, :mobile ].each do |expected_attr|
			it { should respond_to expected_attr }
		end

  end

  context "Validations" do

    # role can't be validated in the same way because of the before validation
		[ :email, :first_name, :home_phone ].each do |validate_attr|
			it { should validate_presence_of(validate_attr) }
		end

		[ :first_name, :last_name ].each do |validate_attr|
			it { should ensure_length_of(validate_attr).is_at_most(50) }
		end

		context "email addresses" do

			it "are validated" do
				should allow_value("user@foo.COM").for(:email)
	  	end

			let(:mixed_case_email) { "Foo@ExAMPLe.CoM"}

			it "with upper-case saved as lower-case" do
				contact.email = mixed_case_email
				contact.save
				contact.reload.email.should eq mixed_case_email.downcase
			end

			it "with bad format are invalid" do
				should_not allow_value("foo@bar_baz.com").for(:email)
			end
		end
	end

	context "#appointments" do

    context "returns expected appointments ordered by date" do

			app1 = app2 = app3 = nil
			before do

				(app2 = FactoryGirl.build(:appointment, :gardener_a, :today_fourth_slot, contact: contact)).save!
				(app3 = FactoryGirl.build(:appointment, :gardener_a, :tomorrow_first_slot, contact: contact)).save!
				(app1 = FactoryGirl.build(:appointment, :gardener_a, :today_first_slot, contact: contact)).save!

				Appointment.all.should eq [app2,app3, app1]
			end

			it "true" do
		  	contact.appointments.should eq [app1, app2, app3]
		  end
    end

    context "only returns appointments for the expected user" do

    	contact1_app1 = contact2_app2 = nil

      before do
	  		contact_2  = FactoryGirl.create(:contact, :client_a)
	      contact1_app1 = FactoryGirl.create(:appointment, :gardener_a, :today_first_slot, contact: contact)
				contact2_app2 = FactoryGirl.create(:appointment, :gardener_a, :today_second_slot, contact: contact_2)
				Appointment.all.should eq [contact1_app1,contact2_app2]
			end

	    it "true" do
        contact.appointments.should eq [contact1_app1]
			end
		end
  end

  context "#visits" do
  	context "returns expected visits ordered by date and time" do

      gardener_a = nil
			contact1_app1 = contact1_app2 = contact1_app3 = nil
			before do
				gardener_a = FactoryGirl.create(:contact, :gardener_a)
				(contact1_app2 = FactoryGirl.create(:appointment, :today_fourth_slot, contact: contact, appointee: gardener_a)).save!
				(contact1_app3 = FactoryGirl.create(:appointment, :tomorrow_first_slot, contact: contact, appointee: gardener_a)).save!
				(contact1_app1 = FactoryGirl.create(:appointment, :gardener_p, :today_first_slot, contact: contact )).save!

				Appointment.all.should eq [contact1_app2,contact1_app3, contact1_app1]
			end

			it "true" do
		  	gardener_a.visits.should eq [contact1_app2, contact1_app3]
		  end
    end

  end

  context "Custom finders" do

    context "#gardeners" do
	  	percy = allan = roger = nil

	 		before do
	 			percy = FactoryGirl.create(:contact, :gardener_p)
		  	allan = FactoryGirl.create(:contact, :gardener_a)
	  		roger = FactoryGirl.create(:contact, :client_r)

	 			Contact.all.should eq [percy,allan,roger]
	 		end

	    it "return first name ordered gardeners" do
		    Contact.contacts_by_role("gardener").should eq [allan, percy]
	    end
		end

		context "#clients" do
	  	roger = ann = alan = nil

	 		before(:all) do
	 			roger = FactoryGirl.create(:contact, :client_r)
		  	ann   = FactoryGirl.create(:contact, :client_a)
	  		alan  = FactoryGirl.create(:contact, :gardener_a)

	 			Contact.all.should eq [roger,ann,alan]
	 		end
	    after(:all) { Contact.destroy_all}

	    it "return first name ordered clients" do
		    Contact.contacts_by_role("client").should eq [ann, roger]
	    end

      context "case insenstive" do
      	john = nil
      	before do
      	 john  = FactoryGirl.create(:contact, :client_j, first_name: "john")
      	 Contact.all.should eq [roger,ann,alan,john]
      	end

	      it "ordering of clients" do
	        Contact.contacts_by_role("client").should eq [ann, john, roger]
	      end

	    end
		end

  end



  context "full_name" do
    its(:full_name) { should eq "Roger Smith"}
	end

	context "#home_phone" do

		it "only save numerics" do
			contact.home_phone = "(0181).,;.300-1234"
			contact.home_phone.should eq "01813001234"
		end

	end

  context "formatted home phone without area code" do
    it "none brum" do
      contact.formatted_home_phone_without_area_code.should eq "0181-100-3003"
    end
    it "Brum" do
      contact.home_phone = "0121-333-1234"
      contact.formatted_home_phone_without_area_code.should eq "333-1234"
    end
  end

  context "#formatted full name plus contact" do
    it "none brum" do
      contact.formatted_full_name_plus_contact.should eq "Roger Smith / 0181-100-3003"
    end
    it "Brum" do
      contact.home_phone = "0121-333-1234"
      contact.formatted_full_name_plus_contact.should eq "Roger Smith / 333-1234"
    end

  end


	context "#mobile" do

		it "only save numerics" do
			contact.mobile = "(0181).,;.300-1234"
			contact.mobile.should eq "01813001234"
		end

	end

	describe "Association" do

		it { should belong_to(:contactable) }
	  it { should have_one(:address).dependent(:destroy) }
	  it { should have_many(:gardens).dependent(:destroy)}
	  it { should have_many(:appointments).dependent(:destroy) }
	  #it { should have_many(:visits).dependent(:destroy) }

	end

end
