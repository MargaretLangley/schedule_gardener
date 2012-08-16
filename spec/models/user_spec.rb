# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  first_name      :string(255)
#  last_name       :string(255)
#  email           :string(255)
#  password_digest :string(255)
#  remember_token  :string(255)
#  phone_number    :string(255)
#  admin           :boolean         default(FALSE)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

# cut and paste into terminal
# User.new(first_name: "Example", last_name: "User", email: "user@example.com", password: "foobar", password_confirmation: "foobar", phone_number: "0121-308-1439") 

require 'spec_helper'

describe User do

	subject(:user) { 
												address = FactoryGirl.build(:address)	

												user = User.new(first_name: "Example", 
												last_name: "User", 
												email: "user@example.com",
												password: "foobar",
												password_confirmation: "foobar", 
												phone_number: "0121-308-1439",
												address_attributes: {
																						street_number: "15",
																						street_name: "High Street",
																						address_line_2: "Stratford",
																						town: "London",
																						post_code: "NE12 3ST"
																						}
												)
									}


	it { should_not allow_mass_assignment_of(:admin) }

	it { should respond_to (:first_name)	}
	it { should respond_to (:last_name)	}
	it { should respond_to (:email) }
	it { should respond_to (:password_digest) }
	it { should respond_to (:password) }
	it { should respond_to (:password_confirmation) }
	it { should respond_to (:remember_token) }
	it { should respond_to (:phone_number) }

	it { should respond_to (:admin) }
	it { should respond_to (:authenticate) }
	it { should respond_to (:address) }
	
	it { should be_valid }

	context "should be valid after saving" do
		before { user.save  }
		it { should be_valid }
	end

	it { should_not be_admin }

	context "with admin attribute set to 'true'" do
		before { user.toggle(:admin) }
		it { should be_admin }
	end

	context "#first_name" do
		it { should validate_presence_of(:first_name) }
		it { should ensure_length_of(:first_name).is_at_most(50) }
	end

	context "#last_name" do
		it { should ensure_length_of(:last_name).is_at_most(50) }
	end

	context "#email" do

		it { should validate_presence_of(:email) }

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
				user.email = mixed_case_email
				user.save
				user.reload.email.should eq mixed_case_email.downcase
			end
		end
	end
	
	context "password" do

		context "invalid" do
			it "when password and confirmation different" do
				user.password_confirmation = "mismatched"
				should_not be_valid
			end
			it { should validate_presence_of(:password_confirmation) }
			it { should ensure_length_of(:password).is_at_least(6)}

		end


		context "valid" do

			context "Updating user doesn't require password" do
				let!(:original_password) {  user.password }
				before do
					user.update_attributes(first_name: "Example2")
					user.reload
				end
				it { should be_valid }
				context "Should not change password" do
					its (:password) { should eq original_password }
				end
			end
		end

	end

	context "authenticate" do
		before do
		 user.save 
		end
		let(:found_user) { User.find_by_email(user.email) }
		
		it { should eq found_user.authenticate(user.password) }

		context "user with wrong authentication should be false"  do
			let(:user_for_invalid_password) { found_user.authenticate("invalid") }
			it { should_not eq user_for_invalid_password }
			specify { user_for_invalid_password.should be_false }
		end
	end


	context "phone_number" do

		it { should validate_presence_of(:phone_number) }

		context "valid"
			it "when phone_number has punctuation" do
				user.phone_number = "(0121).,;.308-1439" 
				user.save
				user.reload.phone_number.should eq "01213081439"
			end
	end

	context "search_ordered" do
 		before(:all) do 
 			3.times { |i| user = FactoryGirl.create(:user, first_name: "Person#{i+1}", last_name: "Surname#{i+1}")  }

 		end
    after(:all) { User.delete_all }

    it "should match only one user" do
    	# Creates an array of matching users and passes them into first_name_array
	    first_name_array = User.search_ordered("Person2").map { |user| user.first_name }
    	first_name_array.should eq ["Person2"]
    end 


    it "should match expected array" do
    	# Creates an array of matching users and passes them into first_name_array
	    first_name_array = User.search_ordered("Person").map { |user| user.first_name }
    	first_name_array.should eq ["Person1", "Person2", "Person3"]
    end 

    it "should be case insenstive" do
	    first_name_array = User.search_ordered("PERSON").map { |user| user.first_name }
    	first_name_array.should eq ["Person1", "Person2", "Person3"]
    end 

    it "should match full name" do
    	first_name_array = User.search_ordered("PERSON1 SURNAME1").map { |user| user.first_name }
    	first_name_array.should eq ["Person1"]
    end
	end


	describe "remember token" do
    before { user.save }
    its(:remember_token) { should_not be_blank }

    it "should generate unique tokens" do
    	pending
    end
  end

	describe "#address" do
    before do 
    	user.save 
  	end

    it "destroying the user should destroy the address" do
      address = user.address
    	user.destroy
      Address.find_by_id(address.id).should be_nil
    end
	end

end
