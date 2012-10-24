# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  password_digest        :string(255)      not null
#  remember_token         :string(255)
#  admin                  :boolean          default(FALSE)
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#  email_verified         :boolean          default(FALSE)
#  verify_email_token     :string(255)
#  verify_email_sent_at   :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
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

		[:admin, :appointments, :authenticate, :email, :full_name, :password, :password_digest, :password_confirmation, :remember_token].each do |expected_attribute|
  		it { should respond_to expected_attribute }
		end

  end

  context "validations" do

		[ :password ].each do |validate_attr|
			it { should validate_presence_of(validate_attr) }
		end

		[ :password ].each do |validate_attr|
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
  end

  context "Custom finders" do

	  context "#find_by_email" do
	  	user1 = user2 = user3 = nil

	  	before(:all) do
	 			user1 =	FactoryGirl.create(:user, :client_j)
	 			user2 =	FactoryGirl.create(:user, :client_a)
	 			user3 =	FactoryGirl.create(:user, :client_r)

	 			User.all.should eq [user1,user2,user3]
	 		end

	    after(:all) { User.destroy_all;  }

			it "return user by email" do
		  	User.find_by_email("ann.abbey@example.com").should eq  user2
	    end

	    it "empty email should not return a user" do
		  	User.find_by_email("").should eq  nil
	    end
	  end

	  context "#search_ordered" do
	  	john = roger = ann = nil

	 		before(:all) do
	 			john = FactoryGirl.create(:user, :client_j)
		  	roger = FactoryGirl.create(:user, :client_r)
	  		ann = FactoryGirl.create(:user, :client_a)

	 			User.all.should eq [john,roger,ann]
	 		end
	    after(:all) { User.destroy_all}

	    it "empty search should return users" do
		    User.search_ordered.should eq [ann, john, roger]
	    end

	    it "unique name match" do
		    User.search_ordered("John").should eq [john]
	    end

	    it "match multiple" do
		    User.search_ordered("Smi").should eq [john, roger]
	    end

	    it "case insenstive" do
		    User.search_ordered("s").should eq [john, roger]
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
