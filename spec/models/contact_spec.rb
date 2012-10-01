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
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#


require 'spec_helper'

describe Contact do
	subject(:contact) { FactoryGirl.build(:contact, first_name: "Roger", last_name: "Smith") }

	include_examples "All Built Objects", Contact

	it "has a valid factory" do
    FactoryGirl.create(:contact).should be_valid
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
			let(:mixed_case_email) { "Foo@ExAMPLe.CoM"}


			it "with good format are valid" do
	      email_addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
	      email_addresses.each do |valid_email_address|
	        should validate_format_of(:email).with(valid_email_address)
	      end
	  	end

			it "with upper-case saved as lower-case" do
				contact.email = mixed_case_email
				contact.save
				contact.reload.email.should eq mixed_case_email.downcase
			end

			it "with bad format are invalid" do
		  	email_addresses = %w[user@foo,com user_at_foo.org example.user@foo.
		                 foo@bar_baz.com foo@bar+baz.com]
		  	email_addresses.each do |invalid_address|
		    	should validate_format_of(:email).not_with(invalid_address)
		  	end
		  end
		end
	end

	context "#appointments" do
		contact1_app1 = contact1_app2 = contact1_app3 = contact2_app4 = nil

		before(:all) do
		  contact_2  = FactoryGirl.create(:contact, first_name: "Simon")
			contact1_app2 = FactoryGirl.create(:appointment, :tomorrow, contact: contact)
			contact1_app1 = FactoryGirl.create(:appointment, :today, contact: contact)
			contact1_app3 = FactoryGirl.create(:appointment, :two_days_time, contact: contact)
			contact2_app4 = FactoryGirl.create(:appointment, :tomorrow, contact: contact_2)

			Appointment.all.should eq [contact1_app2,contact1_app1,contact1_app3,contact2_app4]
		end
		after(:all) { Contact.destroy_all; Appointment.destroy_all; Event.delete_all; }

		it "returns expected appointments" do
	  	contact.appointments.should eq [contact1_app1, contact1_app2, contact1_app3]
	  end

    it "return event with expected title" do
    	contact.appointments.fetch(0).event.title.should eq "created by appointment today"
    end
  end

  context "Custom finders" do

    context "#gardeners" do
	  	percy = allan = roger = nil

	 		before(:all) do
	 			percy = FactoryGirl.create(:contact, first_name: "Percy", last_name: "Thrower", role: :gardener)
		  	allan = FactoryGirl.create(:contact, first_name: "Alan",  last_name: "Titmarsh", role: :gardener)
	  		roger = FactoryGirl.create(:contact, first_name: "Roger", last_name: "Smith", role: :client)

	 			Contact.all.should eq [percy,allan,roger]
	 		end
	    after(:all) { Contact.destroy_all}

	    it "empty search should return first name ordered contacts" do
		    Contact.gardeners.should eq [allan, percy]
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
	  it { should have_many(:events).through(:appointments)}

	end

end
