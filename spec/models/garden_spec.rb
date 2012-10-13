# == Schema Information
#
# Table name: gardens
#
#  id         :integer          not null, primary key
#  contact_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Garden do
  let(:contact) do
    contact = FactoryGirl.create(:contact,:client_a)
  end
  let(:garden) do
    garden = FactoryGirl.build(:garden)
    contact.gardens << garden
    garden
  end
  let(:garden_own_address) do
    garden = FactoryGirl.build(:garden_own_address)
    contact.gardens << garden
    garden
  end


  subject { garden }
  include_examples "All Built Objects", Garden

  context "Garden with own address" do
  	subject { garden_own_address }
    it { should_not be_nil }
	  it { should be_valid }
  end

  context "Validations" do

    # would like to validate contact_id but seems to cause
    # problems. left it in as it would improve data quality
    # [ :contact_id ].each do |validate_attr|
    #   it { should validate_presence_of(validate_attr) }
    # end

  end

  context "Associations" do
  	it { should have_one(:address).dependent(:destroy)}
  	it { should belong_to(:contact)}

  	context "Address" do
  		context "when from contact" do
        it "should match contact" do
			 	  garden.address.should eq garden.contact.address
        end
  		end
  		context "when owned" do
  			subject { garden_own_address }
        it "can be different from contact's address" do
          garden_own_address.address.should_not eq garden_own_address.contact.address
        end
  		end
  	end

	end

end
