# == Schema Information
#
# Table name: touches
#
#  id                     :integer          not null, primary key
#  contact_id             :integer          not null
#  by_phone               :boolean
#  by_visit               :boolean
#  touch_from             :datetime         not null
#  completed              :boolean
#  additional_information :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'spec_helper'

describe Touch do
  before { Timecop.freeze(Time.zone.parse('1/9/2012 8:00')) }
  let!(:client_a) {  FactoryGirl.create(:contact, :client_a) }
  subject(:touch) { FactoryGirl.create(:touch, by_phone: true, contact: client_a) }

  include_examples 'All Built Objects', Touch

  context 'Accessable' do
    [:created_at, :updated_at].each do |validate_attr|
      it { should_not allow_mass_assignment_of(validate_attr) }
    end

    [:additional_information, :by_phone, :by_visit,  :touch_from].each do |expected_attr|
      it { should respond_to expected_attr }
    end
  end

  context 'new record' do
    subject(:new_touch) { Touch.new(contact: client_a) }

    context 'state' do
      it ('phone not be nil') { expect(new_touch.by_phone).to_not be_nil  }
      it ('has no phone')     { expect(new_touch.by_phone).to be false  }
      it ('visit not be nil') { expect(new_touch.by_visit).to_not be_nil  }
      it ('has no visit')     { expect(new_touch.by_visit).to be false  }
      it ('has visit at start of day') { expect(new_touch.touch_from).to eq 'Sat, 01 Sep 2012 00:00:00 BST +01:00'   }
      it ('has touch from today') { expect(new_touch.touch_from).to eq 'Sat, 01 Sep 2012 00:00:00 BST +01:00'   }
      it ('has empty information') { expect(new_touch.additional_information).to eq ''   }
      it ('completed not be nil') { expect(new_touch.completed).to_not be_nil  }
      it ('not comploted')     { expect(new_touch.completed).to eq false  }
      it ('be valid') do
        new_touch.by_phone = true
        expect(new_touch).to be_valid
      end
    end
  end

  context 'invalid' do
    context 'when asked to make appointment' do
      context 'without' do
        it 'a way to contact' do
          touch.by_phone = false
          touch.by_visit = false
          touch.valid?
          expect(touch.errors[:by_phone]).to include('You have to select a way to contact us. Either choose by phone or by visit.')
        end
      end
    end
    context 'when arranging to be contacted' do
      it 'it is in the future' do
        touch.touch_from = '2012/08/31'
        touch.valid?
        expect(touch.errors[:touch_from]).to include('We can contact you from today. Please choose a date which can be today or in the future.')
      end
      it 'it is within a year' do
        touch.touch_from = '2013/09/02'
        touch.valid?
        expect(touch.errors[:touch_from]).to include('We can contact you within a year. Please choose a date within a year from today.')
      end
    end
  end

  context 'Custom finders' do
    context 'ordering' do
      context 'by date order' do
        client_a = ann = john = roger = nil

        before do
          client_a = FactoryGirl.create(:contact, :client_a)
          (ann =  Touch.new(by_phone: true, contact: client_a, touch_from: '2012-09-02')).save!
          john = FactoryGirl.create(:touch, :client_j, :next_week)
          roger = FactoryGirl.create(:touch, :client_r, :today)

          expect(Touch.all).to eq [ann, john, roger]
        end

        after(:all) do
        end

        it ('all ordered') { expect(Touch.all_ordered).to eq [roger, ann, john] }
        it ('outstanding') { expect(Touch.outstanding).to eq [roger, ann, john] }
        it ('outstanding by contact') { expect(Touch.outstanding_by_contact(client_a)).to eq [ann] }
      end

      context 'by date then name' do
        ann = john = roger = nil

        before do
          john = FactoryGirl.create(:touch, :client_j, :tomorrow)
          ann = FactoryGirl.create(:touch, :client_a, :tomorrow)
          roger = FactoryGirl.create(:touch, :client_r, :tomorrow)

          expect(Touch.all).to eq [john, ann, roger]
        end

        it ('all ordered') { expect(Touch.all_ordered).to eq [ann, john, roger] }
        it ('outstanding') { expect(Touch.outstanding).to eq [ann, john, roger] }
      end

      context 'return only outstanding' do
        ann = john =  nil

        before do
          john = FactoryGirl.create(:touch, :client_j, :tomorrow, completed: true)
          ann = FactoryGirl.create(:touch, :client_a, :tomorrow)

          expect(Touch.all).to eq [john, ann]
        end

        it ('outstanding') { expect(Touch.outstanding).to eq [ann] }
      end
    end
  end
end
