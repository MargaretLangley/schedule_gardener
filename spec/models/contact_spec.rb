# == Schema Information
#
# Table name: contacts
#
#  id         :integer         not null, primary key
#  first_name :string(255)
#  last_name  :string(255)
#  email      :string(255)
#  home_phone :string(255)
#  mobile     :string(255)
#  address_id :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#


require 'spec_helper'

describe Contact do

	subject(:contact) { FactoryGirl.build(:contact) }

	context "validate factory" do
		it { should be_valid}
	end

	context "Accessable" do

		[ :contactable_id, :contactable_type].each do |validate_attr|
			it { should_not allow_mass_assignment_of(validate_attr) }
		end

	 [:address, :email, :first_name, :home_phone, :last_name, :mobile ].each do |expected_attr|
			it { should respond_to expected_attr }
		end

  end

  context "Validations" do

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

		describe "#address" do
	    before do 
	    	contact.save 
	  	end

	  	it { should have_one(:address) }

	    it "destroying the contact should destroy the address" do
	      address = contact.address
	    	contact.destroy
	      Address.find_by_id(address.id).should be_nil
	    end
		end
	end

end
