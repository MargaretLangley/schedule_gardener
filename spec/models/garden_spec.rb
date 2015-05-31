# == Schema Information
#
# Table name: gardens
#
#  id         :integer          not null, primary key
#  person_id :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Garden do
  let(:person) do
    FactoryGirl.create(:person, :client_a)
  end
  let(:garden) do
    garden = FactoryGirl.build(:garden)
    person.gardens << garden
    garden
  end
  let(:garden_own_address) do
    garden = FactoryGirl.build(:garden_own_address)
    person.gardens << garden
    garden
  end

  subject { garden }
  include_examples 'All Built Objects', Garden

  context 'Garden with own address' do
    subject { garden_own_address }
    it { should_not be_nil }
    it { should be_valid }
  end

  context 'Validations' do
    # would like to validate person_id but seems to cause
    # problems. left it in as it would improve data quality
    # [ :person_id ].each do |validate_attr|
    #   it { should validate_presence_of(validate_attr) }
    # end
  end

  context 'Associations' do
    it { should have_one(:address).dependent(:destroy) }
    it { should belong_to(:person) }

    context 'Address' do
      context 'when from person' do
        it 'should match person' do
          expect(garden.address).to eq garden.person.address
        end
      end
      context 'when owned' do
        subject { garden_own_address }
        it "can be different from person's address" do
          expect(garden_own_address.address).to_not eq garden_own_address.person.address
        end
      end
    end
  end
end
