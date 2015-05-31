# == Schema Information
#
# Table name: touches
#
#  id                     :integer          not null, primary key
#  person_id             :integer          not null
#  by_phone               :boolean
#  by_visit               :boolean
#  touch_from             :datetime         not null
#  completed              :boolean
#  additional_information :text
#  created_at             :datetime
#  updated_at             :datetime
#

require 'spec_helper'

describe Touch do
  before { Timecop.freeze(Time.zone.parse('1/9/2012 12:00')) }

  context 'new record' do
    subject(:new_touch) { Touch.new }

    describe 'state' do
      it ('phone not be nil') { expect(new_touch.by_phone).to_not be_nil  }
      it ('has no phone')     { expect(new_touch.by_phone).to be false  }
      it ('visit not be nil') { expect(new_touch.by_visit).to_not be_nil  }
      it ('has no visit')     { expect(new_touch.by_visit).to be false  }
      it 'has visit now' do
        expect(new_touch.touch_from).to eq Time.zone.now
      end
      it ('has empty information') { expect(new_touch.additional_information).to eq ''   }
      it ('completed not be nil') { expect(new_touch.completed).to_not be_nil  }
      it ('not completed')     { expect(new_touch.completed).to eq false  }
    end
  end

  context 'invalid' do
    let!(:client_a) { FactoryGirl.create(:person, :client_a) }
    subject(:touch) { FactoryGirl.build(:touch, by_phone: true, person: client_a) }

    describe 'when asked to make appointment' do
      it 'without a way to contact' do
        touch.by_phone = false
        touch.by_visit = false
        touch.valid?

        expect(touch.errors[:how_to_contact_missing])
          .to include('- select a way to contact us. Choose by phone or by visit.')
      end
    end
    describe 'when arranging to be contacted' do
      it 'if arranging for the past' do
        touch.touch_from = '2012/08/31'
        touch.valid?

        expect(touch.errors[:touch_from])
          .to include('from today - please choose a date which can be today or in the future.')
      end
      it 'if arranging in the distant future' do
        touch.touch_from = '2013/09/02'
        touch.valid?

        expect(touch.errors[:touch_from])
          .to include('within a year - please choose a date within a year from today.')
      end
    end
  end

  describe 'Custom finders' do
    describe 'return only outstanding' do
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
