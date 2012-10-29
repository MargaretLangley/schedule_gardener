# == Schema Information
#
# Table name: touches
#
#  id                     :integer          not null, primary key
#  contact_id             :integer
#  by_phone               :boolean
#  by_visit               :boolean
#  touch_from             :datetime
#  between_start          :datetime
#  between_end            :datetime
#  completed              :boolean
#  additional_information :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'spec_helper'

describe Touch do
  before { Timecop.freeze(Time.zone.parse('1/9/2012 8:00')) }
  subject(:touch) { FactoryGirl.create(:touch, :client_r, by_phone: true) }

  include_examples "All Built Objects", Touch

  context "Accessable" do
    [:created_at, :updated_at].each do |validate_attr|
      it { should_not allow_mass_assignment_of(validate_attr) }
    end

    [:additional_information,:between_end, :between_start, :by_phone, :by_visit,  :touch_from].each do |expected_attr|
      it { should respond_to expected_attr }
    end
  end

  context "new record" do
    subject(:new_touch) { Touch.new(contact: @contact) }

    context "state" do
      it ("phone not be nil") { new_touch.by_phone.should_not be_nil  }
      it ("has no phone")     { new_touch.by_phone.should be_false  }
      it ("visit not be nil") { new_touch.by_visit.should_not be_nil  }
      it ("has no visit")     { new_touch.by_visit.should be_false  }
      it ("has visit at start of day") { new_touch.touch_from.should == 'Sat, 01 Sep 2012 00:00:00 BST +01:00'   }
      it ("has touch from today") { new_touch.touch_from.should == 'Sat, 01 Sep 2012 00:00:00 BST +01:00'   }
      it ("has between start from today") { new_touch.between_start.should == 'Sat, 01 Sep 2012 00:00:00 BST +01:00'   }
      it ("has between end in one year") { new_touch.between_end.should == 'Sat, 01 Sep 2013 00:00:00 BST +01:00'   }
      it ("has empty information") { new_touch.additional_information.should == ''   }
      it ("completed not be nil") { new_touch.completed.should_not be_nil  }
      it ("not comploted")     { new_touch.completed.should be_false  }
      it ("be valid") do
        new_touch.by_phone = true
        new_touch.should be_valid
     end
    end
  end


  context "invalid" do
    context 'when asked to make appointment' do
      context "without" do
        it "a way to contact" do
          touch.by_phone = false
          touch.by_visit = false
          touch.valid?
          touch.errors[:by_phone].should include('You have to select a way to contact us. Either choose by phone or by visit.')
        end
      end
      context "which begins" do
        it 'before today' do
          touch.between_start = "2012/08/31"
          touch.valid?
          touch.errors[:between_start].should include('You asked for a range of appointment dates than begins before today. Please choose a start date from today.')
        end
        it 'after a year in the future' do
          touch.between_start = "2013/09/02"
          touch.valid?
          touch.errors[:between_start].should include('You asked for a range of appointment dates that starts in more than a year. Please choose an start date within a year.')
        end
      end
      context "which ends" do
        it 'after a year in the future' do
          touch.between_end = "2013/09/02"
          touch.valid?
          touch.errors[:between_end].should include('You asked for a range of appointment dates that ends in more than a year. Please choose an end date within a year.')
        end
        it "before it begins" do
          touch.between_start = "2012/09/10"
          touch.between_end = "2012/09/02"
          touch.valid?
          touch.errors[:between_end].should include('You asked for a range of appointments that end before they begin. Please choose an end date after the start date.')
        end
      end
    end
    context "when arranging to be contacted" do
      it 'it is in the future' do
        touch.touch_from = "2012/08/31"
        touch.valid?
        touch.errors[:touch_from].should include('We can contact you from today. Please choose a date which can be today or in the future.')
      end
      it "it is within a year" do
        touch.touch_from = "2013/09/02"
        touch.valid?
        touch.errors[:touch_from].should include('We can contact you within a year. Please choose a date within a year from today.')
      end
    end
  end

   context "Custom finders" do

    context "ordering" do
      context "by date order" do
        ann = john = roger = nil

        before do
          ann = FactoryGirl.create(:touch, :client_a, :tomorrow)
          john = FactoryGirl.create(:touch, :client_j, :next_week)
          roger = FactoryGirl.create(:touch, :client_r, :today)

          Touch.all.should eq [ann,john,roger]
        end

        it "correctly" do
          Touch.completed().should eq [roger, ann, john]
        end
      end

      context "by date then name" do
        ann = john = roger = nil

        before do
          john = FactoryGirl.create(:touch, :client_j, :tomorrow)
          ann = FactoryGirl.create(:touch, :client_a, :tomorrow)
          roger = FactoryGirl.create(:touch, :client_r, :tomorrow)

          Touch.all.should eq [john,ann,roger]
        end

      it "by date order" do
        Touch.completed().should eq [ann, john, roger]
      end

      end
    end

  end



end
