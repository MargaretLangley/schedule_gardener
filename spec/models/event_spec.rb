# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  title       :string(255)      not null
#  starts_at   :datetime         not null
#  ends_at     :datetime
#  all_day     :boolean          default(FALSE)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#


require 'spec_helper'
include ActionView::Helpers::DateHelper
require 'active_support/core_ext/time/calculations'


describe Event do
  subject(:event) { FactoryGirl.build(:event, :today, title: "event_spec_subject") }
  include_examples "All Built Objects", Event

  context "Accessable" do

		[ :created_at, :updated_at].each do |validate_attr|
			it { should_not allow_mass_assignment_of(validate_attr) }
		end

	 [:all_day, :description, :ends_at, :starts_at, :title ].each do |expected_attr|
			it { should respond_to expected_attr }
		end
	end

	context "Validations" do

		[ :starts_at, :title ].each do |validate_attr|
			it { should validate_presence_of(validate_attr) }
		end

		[ :title ].each do |validate_attr|
			it { should ensure_length_of(validate_attr).is_at_most(50) }
		end

	end

	context "Custom finders" do

	  context "#in_time_range" do

	 		context "on boundary" do
	 		  e1 = e2 = e3 = e4 = nil
	 		  before(:all) do
		 			e1 = FactoryGirl.create(:event, title: "e1_on_boundary", starts_at: Time.now.utc.beginning_of_month.advance(hours: -4))
		 			e2 = FactoryGirl.create(:event, title: "e2_on_boundary", starts_at: Time.now.utc.beginning_of_month.advance(hours: 1))
		 			e3 = FactoryGirl.create(:event, title: "e3_on_boundary", starts_at: Time.now.utc.end_of_month.advance(hours: -4))
		 			e4 = FactoryGirl.create(:event, title: "e4_on_boundary", starts_at: Time.now.utc.end_of_month.advance(hours: 4))
		 			Event.all.should eq [e1, e2,e3,e4]
		 		end
		    after(:all) { Event.destroy_all}

		    it "suceeds" do
			    Event.in_time_range(Time.now.utc.beginning_of_month..
			    	                 			Time.now.utc.end_of_month,
			    	                 			).should eq [e2,e3]
		    end
		  end

		  context "accross boundary" do
			  e1 = e2 = nil
	 		  before(:all) do
	 		  	e1 = FactoryGirl.create(:event, title: "e1_accross_boundary", starts_at: Time.now.utc.beginning_of_month.advance(hours: -2))
	 			  e2 = FactoryGirl.create(:event, title: "e2_accross_boundary", starts_at: Time.now.utc.end_of_month.advance(hours: - 1))


		 			Event.all.should eq [e1, e2]
		 		end
		    after(:all) { Event.destroy_all}

		    it "suceeds" do
			    Event.in_time_range(Time.now.utc.beginning_of_month..
			    	                 		 Time.now.utc.end_of_month,
			    	                 		 ).should eq [e1,e2]
		    end
      end

		  context "nil end" do
			  e1 = e2 = nil
	 		  before(:all) do
	 		  	e1 = FactoryGirl.create(:event, title: "e1_nil_end", ends_at: nil, starts_at: Time.now.utc.beginning_of_month.advance(hours: + 10))
		 			Event.all.should eq [e1]
		 		end
		    after(:all) { Event.destroy_all}

		    it "suceeds" do
			    Event.in_time_range(Time.now.utc.beginning_of_month..
			    	              	  	 Time.now.utc.end_of_month,
			    	                	 	 ).should eq [e1]
		    end
      end

    end

	end



	describe "Association" do
  	it { should have_many(:appointments).dependent(:destroy) }
  end
end
