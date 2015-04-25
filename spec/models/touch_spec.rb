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
#  created_at             :datetime
#  updated_at             :datetime
#

require 'spec_helper'

describe Touch do
  before { Timecop.freeze(Time.zone.parse('1/9/2012 12:00')) }

  context 'new record' do
    let!(:client_a) {  FactoryGirl.create(:contact, :client_a) }
    subject(:new_touch) { Touch.new(contact: client_a) }

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
      it ('be valid') do
        new_touch.by_phone = true
        expect(new_touch).to be_valid
      end
    end
  end

  context 'invalid' do
    let!(:client_a) {  FactoryGirl.create(:contact, :client_a) }
    subject(:touch) { FactoryGirl.create(:touch, by_phone: true, contact: client_a) }

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

  describe 'Custom finders - ordering' do
    describe 'by date order' do
      ann = john = roger = nil

      before do
        ann = FactoryGirl.create(:touch, :client_a, :next_week)
        john = FactoryGirl.create(:touch, :client_j, :fortnight)
        roger = FactoryGirl.create(:touch, :client_r, :tomorrow)

        expect(Touch.all).to eq [ann, john, roger]
      end

      it 'outstanding' do
        expect(Touch.outstanding).to eq [roger, ann, john]
      end
      it 'outstanding by contact' do
        contact_john = Contact.find_by first_name: 'John'

        expect(Touch.outstanding_by_contact(contact_john)).to eq [john]
      end
    end

    describe 'by date then name' do
      ann = john = roger = nil

      before do
        john = FactoryGirl.create(:touch, :client_j, :tomorrow)
        ann = FactoryGirl.create(:touch, :client_a, :tomorrow)
        roger = FactoryGirl.create(:touch, :client_r, :tomorrow)

        expect(Touch.all).to eq [john, ann, roger]
      end

      it ('outstanding') { expect(Touch.outstanding).to eq [ann, john, roger] }
    end

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
