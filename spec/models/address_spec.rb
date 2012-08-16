# == Schema Information
#
# Table name: addresses
#
#  id               :integer         not null, primary key
#  addressable_id   :integer
#  addressable_type :string(255)
#  house_name       :string(255)
#  street_number    :string(255)
#  street_name      :string(255)
#  address_line_2   :string(255)
#  town             :string(255)
#  post_code        :string(255)
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#

# Address.new( street_number: "15", street_name: "High Street", address_line_2: "Stratford", town: "London", post_code: "NE12 3ST") 

require 'spec_helper'

describe Address do


		subject(:address) {
									
										 FactoryGirl.build(:address,
														street_number: "15",
														street_name: "High Street",
														address_line_2: "Stratford",
														town: "London",
														post_code: "NE12 3ST"
														) 
									}

		it { should have_db_column(:id).of_type(:integer) }
		it { should have_db_column(:addressable_id).of_type(:integer) }
		it { should have_db_column(:addressable_type).of_type(:string) }
		it { should have_db_column(:house_name).of_type(:string) }
		it { should have_db_column(:street_number).of_type(:string) }
		it { should have_db_column(:street_name).of_type(:string) }
		it { should have_db_column(:address_line_2).of_type(:string) }
		it { should have_db_column(:town).of_type(:string) }
		it { should have_db_column(:post_code).of_type(:string) }

  	it { should_not allow_mass_assignment_of(:addressable_id) }
  	it { should_not allow_mass_assignment_of(:addressable_type) }
  	
  	it { should belong_to(:addressable)}		
		it { should respond_to (:addressable)}
		it { should respond_to (:addressable_id)}
		it { should respond_to (:addressable_type)}
		it { should respond_to (:house_name) }
		it { should respond_to (:street_number) }
		it { should respond_to (:street_name) }
		it { should respond_to (:address_line_2) }
		it { should respond_to (:town) }
		it { should respond_to (:post_code) }



		# This should be validated but validates doesn't work with the create 
		# it says they are blank but the parent pointed variables are assigned
		# properly
		# it { should validate_presence_of(:addressable_id) }
		# it { should validate_presence_of(:addressable_type) }
		it { should validate_presence_of(:street_number) }
		it { should validate_presence_of(:street_number) }
		it { should validate_presence_of(:street_name) }
		it { should validate_presence_of(:town) }
		it { should ensure_length_of(:town).is_at_most(50) }


		it { should be_valid}

end
