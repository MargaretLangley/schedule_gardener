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

	subject(:contact) { 
												user = Contact.new(
													first_name: "Example", 
													last_name: "User", 
													email: "user@example.com",
													home_phone: "0121-308-1439",
													address_attributes: {
																							street_number: "15",
																							street_name: "High Street",
																							address_line_2: "Stratford",
																							town: "London",
																							post_code: "NE12 3ST"
																							}
												)
									}

	it { should respond_to (:address) }
	it { should respond_to (:email) }
	it { should respond_to (:first_name)	}
	it { should respond_to (:home_phone) }
	it { should respond_to (:last_name)	}
	it { should respond_to (:mobile)	}


	it { should validate_presence_of(:email) }
	it { should validate_presence_of(:first_name) }
	it { should ensure_length_of(:first_name).is_at_most(50) }
	it { should validate_presence_of(:home_phone) }
	it { should ensure_length_of(:last_name).is_at_most(50) }

	context "#email" do

		context "invalid" do

			it "when format wrong" do
      	email_addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      	email_addresses.each do |invalid_address|
        should validate_format_of(:email).not_with(invalid_address)
      	end
      end
		end


		context	"valid" do

			it "should handle these email addresses" do
	      email_addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
	      email_addresses.each do |valid_email_address|
	        should validate_format_of(:email).with(valid_email_address)
	      end      
    	end
		end

		context "email addresses with mixed case" do
			let(:mixed_case_email) { "Foo@ExAMPLe.CoM"}

			it "should be saved as all lower-case" do
				contact.email = mixed_case_email
				contact.save
				contact.reload.email.should eq mixed_case_email.downcase
			end
		end
	end


	context "#home_phone" do

		context "valid"
			it "when home phone has punctuation" do
				contact.home_phone = "(0181).,;.300-1234" 
				contact.save 
				contact.reload.home_phone.should eq "01813001234"
			end
	end
	
	context "#mobile" do

		context "valid "
			it "when home phone has punctuation" do
				contact.mobile = "(0181).,;.300-1234" 
				contact.save 
				contact.reload.mobile.should eq "01813001234"
			end
	end

	describe "#address" do
    before do 
    	contact.save 
  	end

    it "destroying the contact should destroy the address" do
      address = contact.address
    	contact.destroy
      Address.find_by_id(address.id).should be_nil
    end
	end
end
