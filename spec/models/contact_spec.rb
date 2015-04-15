# == Schema Information
#
# Table name: contacts
#
#  id               :integer          not null, primary key
#  contactable_id   :integer
#  contactable_type :string(255)
#  first_name       :string(255)      not null
#  last_name        :string(255)
#  email            :string(255)
#  home_phone       :string(255)      not null
#  mobile           :string(255)
#  role             :string(255)      not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'spec_helper'

describe Contact do
  before { Timecop.freeze(Time.zone.parse('1/9/2012 8:00')) }
  subject(:contact) { FactoryGirl.build(:contact, :client_r) }

  include_examples 'All Built Objects', Contact

  it 'has a valid factory' do
    expect(FactoryGirl.create(:contact, :client_r)).to be_valid
  end

  context 'Validations' do
    # role can't be validated in the same way because of the before validation
    [:email, :first_name, :home_phone].each do |validate_attr|
      it { should validate_presence_of(validate_attr) }
    end

    [:first_name, :last_name].each do |validate_attr|
      it { should validate_length_of(validate_attr).is_at_most(50) }
    end

    context 'email addresses' do
      it 'are validated' do
        should allow_value('user@foo.COM').for(:email)
      end

      let(:mixed_case_email) { 'Foo@ExAMPLe.CoM' }

      it 'with upper-case saved as lower-case' do
        contact.email = mixed_case_email
        contact.save
        expect(contact.reload.email).to eq mixed_case_email.downcase
      end

      it 'with bad format are invalid' do
        should_not allow_value('foo@bar_baz.com').for(:email)
      end
    end
  end

  context '#appointments' do
    context 'returns expected appointments ordered by date' do
      app1 = app2 = app3 = nil
      before do
        (app2 = FactoryGirl.build(:appointment, :gardener_a, :today_fourth_slot, contact: contact)).save!
        (app3 = FactoryGirl.build(:appointment, :gardener_a, :tomorrow_first_slot, contact: contact)).save!
        (app1 = FactoryGirl.build(:appointment, :gardener_a, :today_first_slot, contact: contact)).save!

        expect(Appointment.all).to eq [app2, app3, app1]
      end

      it 'true' do
        expect(contact.appointments).to eq [app1, app2, app3]
      end
    end

    context 'only returns appointments for the expected user' do
      contact1_app1 = contact2_app2 = nil

      before do
        contact_2  = FactoryGirl.create(:contact, :client_a)
        contact1_app1 = FactoryGirl.create(:appointment, :gardener_a, :today_first_slot, contact: contact)
        contact2_app2 = FactoryGirl.create(:appointment, :gardener_a, :today_second_slot, contact: contact_2)
        expect(Appointment.all).to eq [contact1_app1, contact2_app2]
      end

      it 'true' do
        expect(contact.appointments).to eq [contact1_app1]
      end
    end
  end

  context '#visits' do
    context 'returns expected visits ordered by date and time' do
      gardener_a = nil
      contact1_app1 = contact1_app2 = contact1_app3 = nil
      before do
        gardener_a = FactoryGirl.create(:contact, :gardener_a)
        (contact1_app2 = FactoryGirl.create(:appointment, :today_fourth_slot, contact: contact, appointee: gardener_a)).save!
        (contact1_app3 = FactoryGirl.create(:appointment, :tomorrow_first_slot, contact: contact, appointee: gardener_a)).save!
        (contact1_app1 = FactoryGirl.create(:appointment, :gardener_p, :today_first_slot, contact: contact)).save!

        expect(Appointment.all).to eq [contact1_app2, contact1_app3, contact1_app1]
      end

      it 'true' do
        expect(gardener_a.visits).to eq [contact1_app2, contact1_app3]
      end
    end
  end

  context 'Custom finders' do
    context '#gardeners' do
      percy = allan = roger = nil

      before do
        percy = FactoryGirl.create(:contact, :gardener_p)
        allan = FactoryGirl.create(:contact, :gardener_a)
        roger = FactoryGirl.create(:contact, :client_r)

        expect(Contact.all).to eq [percy, allan, roger]
      end

      it 'return first name ordered gardeners' do
        expect(Contact.contacts_by_role('gardener')).to eq [allan, percy]
      end
    end

    context '#clients' do
      roger = ann = alan = nil

      before(:all) do
        roger = FactoryGirl.create(:contact, :client_r)
        ann   = FactoryGirl.create(:contact, :client_a)
        alan  = FactoryGirl.create(:contact, :gardener_a)

        expect(Contact.all).to eq [roger, ann, alan]
      end
      after(:all) { Contact.destroy_all }

      it 'return first name ordered clients' do
        expect(Contact.contacts_by_role('client')).to eq [ann, roger]
      end

      context 'case insenstive' do
        john = nil
        before do
          john  = FactoryGirl.create(:contact, :client_j, first_name: 'john')
          expect(Contact.all).to eq [roger, ann, alan, john]
        end

        it 'ordering of clients' do
          expect(Contact.contacts_by_role('client')).to eq [ann, john, roger]
        end
      end
    end
  end

  it 'full_name is correct' do
    expect(contact.full_name).to eq 'Roger Smith'
  end

  context '#home_phone' do
    it 'only save numerics' do
      contact.home_phone = '(0181).,;.300-1234'
      expect(contact.home_phone).to eq '01813001234'
    end
  end

  context '#mobile' do
    it 'only save numerics' do
      contact.mobile = '(0181).,;.300-1234'
      expect(contact.mobile).to eq '01813001234'
    end
  end

  describe 'Association' do
    it { should belong_to(:contactable) }
    it { should have_one(:address).dependent(:destroy) }
    it { should have_many(:gardens).dependent(:destroy) }
    it { should have_many(:appointments).dependent(:destroy) }
    # it { should have_many(:visits).dependent(:destroy) }
  end
end
