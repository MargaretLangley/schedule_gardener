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

	include_examples "All Built Objects", User

	context "validate factory" do
		it { should_not be_admin }
	end

	context "Accessable" do

		[ :admin ].each do |validate_attr|
			it { should_not allow_mass_assignment_of(validate_attr) }
		end

		[:admin, :authenticate, :password, :password_digest, :password_confirmation, :remember_token].each do |expected_attribute|
  		it { should respond_to expected_attribute }
		end

  end

  context "validations" do

		[ :password, :password_confirmation ].each do |validate_attr|
			it { should validate_presence_of(validate_attr) }
		end

		[ :password, :password_confirmation ].each do |validate_attr|
			it { should ensure_length_of(validate_attr).is_at_least(6) }
		end

		it "invalid with different password and confirmation" do
			user.password_confirmation = "mismatched"
			should_not be_valid
		end

  end

	context "#toggle admin" do
		before { user.toggle(:admin) }
		it { should be_admin }
	end
	
	context "#authenticate" do

		it "with valid password succeeds" do
			user.authenticate(user.password).should be_true
		end

		it "with invalid password fails" do
			user.authenticate("InvalidPassword").should be_false
		end

	end

	describe "remember token" do
    before { user.save }
    its(:remember_token) { should_not be_blank }

    it "should generate unique tokens" do
    	pending
    end
  end

  context "Custom finders" do

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
	  	fred = john = sally = nil
	 		
	 		before(:all) do 
	 			john = FactoryGirl.create(:user, contact: FactoryGirl.create(:contact, first_name: "John", last_name: "Smith")  ) 
		  	sally = FactoryGirl.create(:user, contact: FactoryGirl.create(:contact, first_name: "Sally", last_name: "Jones")  ) 
	  		fred = FactoryGirl.create(:user, contact: FactoryGirl.create(:contact, first_name: "Fred", last_name: "Jone")  ) 

	 			User.all.should eq [john,sally,fred]
	 		end
	    after(:all) { User.destroy_all}

	    it "empty search should return users" do
		    User.search_ordered.should eq [fred, john, sally]
	    end 

	    it "unique name match" do
		    User.search_ordered("John").should eq [john]
	    end 

	    it "match multiple" do
		    User.search_ordered("Jon").should eq [fred, sally]
	    end 

	    it "case insenstive" do
		    User.search_ordered("s").should eq [john, sally]
	    end 

	    it "should match full name" do
	    	User.search_ordered("John Smith").should eq [john]
	    end
		end

	end

	describe "Association" do
	  it { should have_one(:contact).dependent(:destroy) }
	end
end
