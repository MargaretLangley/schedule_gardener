# == Schema Information
#
# Table name: contacts
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

describe Contact do
  before { Timecop.freeze(Time.zone.parse('1/9/2012 12:00')) }

  context 'new record' do
    subject(:new_contact) { Contact.new }

    describe 'state' do
      it ('phone not be nil') { expect(new_contact.by_phone).to_not be_nil  }
      it ('has no phone')     { expect(new_contact.by_phone).to be false  }
      it ('visit not be nil') { expect(new_contact.by_visit).to_not be_nil  }
      it ('has no visit')     { expect(new_contact.by_visit).to be false  }
      it 'has visit now' do
        expect(new_contact.touch_from).to eq Time.zone.now
      end
      it ('has empty information') { expect(new_contact.additional_information).to eq ''   }
      it ('completed not be nil') { expect(new_contact.completed).to_not be_nil  }
      it ('not completed')     { expect(new_contact.completed).to eq false  }
    end
  end

  context 'invalid' do
    let!(:client_a) { FactoryGirl.create(:person, :client_a) }
    subject(:contact) { FactoryGirl.build(:contact, by_phone: true, person: client_a) }

    describe 'when asked to make appointment' do
      it 'without a way to contact' do
        contact.by_phone = false
        contact.by_visit = false
        contact.valid?

        expect(contact.errors[:how_to_contact_missing])
          .to include('- select a way to contact us. Choose by phone or by visit.')
      end
    end
    describe 'when arranging to be contacted' do
      it 'if arranging for the past' do
        contact.touch_from = '2012/08/31'
        contact.valid?

        expect(contact.errors[:touch_from])
          .to include('from today - please choose a date which can be today or in the future.')
      end
      it 'if arranging in the distant future' do
        contact.touch_from = '2013/09/02'
        contact.valid?

        expect(contact.errors[:touch_from])
          .to include('within a year - please choose a date within a year from today.')
      end
    end
  end

  describe 'Custom finders' do
    describe 'return only outstanding' do
      ann = john =  nil

      before do
        john = FactoryGirl.create(:contact, :client_j, :tomorrow, completed: true)
        ann = FactoryGirl.create(:contact, :client_a, :tomorrow)

        expect(Contact.all).to eq [john, ann]
      end

      it ('outstanding') { expect(Contact.outstanding).to eq [ann] }
    end
  end
end
