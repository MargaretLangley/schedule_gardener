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
#  home_phone    :string(255)
#  admin           :boolean         default(FALSE)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

# cut and paste into terminal
# User.new(first_name: "Example", last_name: "User", email: "user@example.com", password: "foobar", password_confirmation: "foobar", home_phone: "0121-308-1439") 

require 'spec_helper'

describe User do

	subject(:user) { FactoryGirl.build(:user) }

	describe "#contact" do
    before do 
    	user.save 
  	end

    it "destroying the contact should destroy the address" do
      contact = user.contact
      address = contact.address
    	user.destroy
      Contact.find_by_id(contact.id).should be_nil
      Address.find_by_id(address.id).should be_nil
    end
	end

	it { should_not allow_mass_assignment_of(:admin) }

	it { should respond_to (:password_digest) }
	it { should respond_to (:password) }
	it { should respond_to (:password_confirmation) }
	it { should respond_to (:remember_token) }

	it { should respond_to (:admin) }
	it { should respond_to (:authenticate) }
	
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
	
	context "password" do

		context "invalid" do
			it "when password and confirmation different" do
				user.password_confirmation = "mismatched"
				should_not be_valid
			end
			it { should validate_presence_of(:password_confirmation) }
			it { should ensure_length_of(:password).is_at_least(6)}
		end
	end

	context "authenticate" do
		before do
			user.save 
		end
		let(:found_user) { User.find_by_id(user.id) }
		
		it { should eq found_user.authenticate(user.password) }

		context "user with wrong authentication should be false"  do
			let(:user_for_invalid_password) { found_user.authenticate("invalid") }
			it { should_not eq user_for_invalid_password }
			specify { user_for_invalid_password.should be_false }
		end
	end

	describe "remember token" do
    before { user.save }
    its(:remember_token) { should_not be_blank }

    it "should generate unique tokens" do
    	pending
    end
  end

  context "#find_by_email" do
  	before(:all) do 
 			3.times do |i| 
 				FactoryGirl.create(:user, contact: FactoryGirl.create(:contact, first_name: "Firstname#{i+1}", email: "firstname#{i+1}@example.com") )
 			end
 		end
    after(:all) { User.destroy_all }

		it "empty search should return users" do
	  	User.find_by_email("firstname2@example.com").first_name.should eq  "Firstname2"
    end 
  end

  context "#search_ordered" do
 		before(:all) do 
 			3.times { |i| FactoryGirl.create(:user, contact: FactoryGirl.create(:contact, first_name: "Firstname#{i+1}", last_name: "Lastname#{i+1}")  ) }
 		end
    after(:all) { User.destroy_all}

    it "empty search should return users" do
    	# Creates an array of matching contacts and passes them into first_name_array
	    first_name_array = User.search_ordered().map { |user| user.contact.first_name }
    	first_name_array.should eq ["Firstname1", "Firstname2", "Firstname3"]
    end 

    it "should match only one contact" do
    	# Creates an array of matching contacts and passes them into first_name_array
	    first_name_array = User.search_ordered("Firstname2").map { |user| user.contact.first_name }
    	first_name_array.should eq ["Firstname2"]
    end 

    it "should match expected array" do
    	# Creates an array of matching contacts and passes them into first_name_array
	    first_name_array = User.search_ordered("Firstname").map { |user| user.contact.first_name }
    	first_name_array.should eq ["Firstname1", "Firstname2", "Firstname3"]
    end 

    it "should be case insenstive" do
	    first_name_array = User.search_ordered("FIRSTNAME").map { |user| user.contact.first_name }
    	first_name_array.should eq ["Firstname1", "Firstname2", "Firstname3"]
    end 

    it "should match full name" do
    	first_name_array = User.search_ordered("FIRSTNAME1 LASTNAME1").map { |user| user.contact.first_name }
    	first_name_array.should eq ["Firstname1"]
    end
	end
end
