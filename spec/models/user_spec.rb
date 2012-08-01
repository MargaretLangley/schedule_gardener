# == Schema Information
#
# Table name: users
#
#  id                  :integer         not null, primary key
#  first_name          :string(255)
#  last_name           :string(255)
#  email               :string(255)
#  address_line_1      :string(255)
#  address_line_2      :string(255)
#  town                :string(255)
#  post_code           :string(255)
#  phone_number        :string(255)
#  garden_requirements :text
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#

require 'spec_helper'

describe User do

	before { @user = User.new(first_name: "Example", 
														last_name: "User", 
														email: "user@example.com",
														password: "foobar",
														password_confirmation: "foobar", 
														address_line_1: "55 Essex Road",
														town: "Sutton Coldfield",
														phone_number: "0121-308-1439") 
				}

	subject { @user }

	it { should respond_to (:first_name)	}
	it { should respond_to (:last_name)	}
	it { should respond_to (:email) }
	it { should respond_to (:password_digest) }
	it { should respond_to (:password) }
	it { should respond_to (:password_confirmation) }
	it { should respond_to (:remember_token) }
	it { should respond_to (:address_line_1) }
	it { should respond_to (:address_line_2) }
	it { should respond_to (:town) }
	it { should respond_to (:post_code) }
	it { should respond_to (:phone_number) }
	it { should respond_to (:garden_requirements) }

	it { should respond_to(:admin) }
	it { should respond_to (:authenticate) }

	it { should be_valid }
	it { should_not be_admin }

	context "with admin attribute set to 'true'" do
		before { @user.toggle(:admin) }

		it { should be_admin }
	end

	context "accessible attributes" do
		it "should not allow acess to admin" do
			expect { User.new(admin: true)}.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
	end

	context "first_name" do

		context "invalid" do

			it "when first_name missing" do
				@user.first_name = " "
				@user.should_not be_valid
			end

			it "when name too long" do
				@user.first_name = "a" * 51
				@user.should_not be_valid
			end

		end

	end

	context "last_name" do

		# it "invalid when last_name missing" do
		# 	@user.last_name = " "
		# 	@user.should_not be_valid
		# end

			it "when name too long" do
				@user.last_name = "a" * 51
				@user.should_not be_valid
			end
	end

	context "email" do

		context "invalid" do
			# Records are v poor and missing most info
			#it "when email missing" do
			#	@user.email = ""
			# 	@user.should_not be_valid
			# end

			it "when format wrong" do
      	addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      	addresses.each do |invalid_address|
        	@user.email = invalid_address
        	@user.should_not be_valid
      	end
      end

      # it "for email duplicate" do
      # 	user_with_same_email = @user.dup
      # 	user_with_same_email.email = @user.email.upcase
      # 	user_with_same_email.save

      # 	should_not be_valid

      # end
		end


		context	"valid" do

			it "when email missing" do
				@user.email = ""
				@user.should be_valid
			end

			it "should handle these email addresses" do
	      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
	      addresses.each do |valid_address|
	        @user.email = valid_address
	        @user.should be_valid
	      end      
    	end
		end

		context "email addresses with mixed case" do
			let(:mixed_case_email) { "Foo@ExAMPLe.CoM"}

			it "should be saved as all lower-case" do
				@user.email = mixed_case_email
				@user.save
				@user.reload.email.should eq mixed_case_email.downcase
			end
		end
	end
	
	context "password" do

		context "invalid" do
			it "when missing" do
				@user.password = @user.password_confirmation = " "
				should_not be_valid
			end

			it "when password and confirmation different" do
				@user.password_confirmation = "mismatched"
				should_not be_valid
			end

			it "when confirmation is nil" do
				@user.password_confirmation = nil
				should_not be_valid
			end

		 	context "with a password that's too short" do
    		before { @user.password = @user.password_confirmation = "a" * 5 }
    		it { should be_invalid }
  		end

		end


		context "valid" do

			context "Updating user doesn't require password" do
				let(:original_password) { @original_password = @user.password }
				before do
					@user.update_attributes(first_name: "Example2")
					@user.reload
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
		 @user.save 
		end
		let(:found_user) { User.find_by_email(@user.email) }

		
		it { should eq found_user.authenticate(@user.password) }

		context "user with wrong authentication should be false"  do
			let(:user_for_invalid_password) { found_user.authenticate("invalid") }
			it { should_not eq user_for_invalid_password }
			specify { user_for_invalid_password.should be_false }
		end
	end


	context "address_line_1" do
		it "invalid when address_line_1 missing" do
			@user.address_line_1 = " "
			@user.should_not be_valid
		end
	end

	context "town" do

		context "invalid" do
			it "when town missing" do
				@user.town = " "
				@user.should_not be_valid
			end

			it "when name too long" do
				@user.town = "a" * 51
				@user.should_not be_valid
			end
		end
	end

	context "phone_number" do
		context "invalid" do
			it "when phone_number missing" do
				@user.phone_number = ""
				@user.should_not be_valid
			end
		end

		context "valid"
			it "when phone_number has punctuation" do
				@user.phone_number = "(0121).,;.308-1439" 
				@user.save
				@user.reload.phone_number.should eq "01213081439"
			end
	end

	context "search_ordered" do
 		before(:all) do 
 			3.times { |i| user = FactoryGirl.create(:user, first_name: "Person #{i+1}")  }
 			FactoryGirl.create(:user, first_name: "Person 0")
 		end
    after(:all) { User.delete_all }

    it "count" do
	    first_name_array = User.search_ordered("Person").map { |user| user.first_name }
    	first_name_array.should eq ["Person 0", "Person 1", "Person 2", "Person 3"]
    end 
	end


	describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }

    it "should generate unique tokens" do
    	pending
    end
  end
end

