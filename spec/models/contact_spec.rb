# == Schema Information
#
# Table name: contacts
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  first_name :string(255)      not null
#  last_name  :string(255)
#  email      :string(255)
#  home_phone :string(255)      not null
#  mobile     :string(255)
#  role       :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Contact do
  before { Timecop.freeze(Time.zone.parse('1/9/2012 8:00')) }
  subject(:contact) { FactoryGirl.build(:user, :client_r).contact }

  include_examples 'All Built Objects', Contact

  describe 'Validations' do
    # role can't be validated in the same way because of the before validation
    [:first_name, :home_phone].each do |validate_attr|
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

  describe 'ordering' do
    def create_appointment(date:, contact: nil, gardener: nil)
      contact = FactoryGirl.build(:user, :client_r).contact unless contact
      gardener = FactoryGirl.build(:user, :gardener_a).contact unless gardener
      FactoryGirl.create(:appointment,
                         date,
                         contact: contact,
                         appointee: gardener)
    end

    describe '#appointments' do
      it 'returns expected appointments ordered by date' do
        app2 = create_appointment(date: :today_fourth_slot, contact: contact)
        app3 = create_appointment(date: :tomorrow_first_slot, contact: contact)
        app1 = create_appointment(date: :today_first_slot, contact: contact)
        expect(Appointment.all).to eq [app2, app3, app1]

        expect(contact.appointments).to eq [app1, app2, app3]
      end
    end

    describe '#visits' do
      it 'returns expected visits ordered by date' do
        gardener = FactoryGirl.build(:user, :gardener_a).contact unless gardener
        app2 = create_appointment date: :today_fourth_slot, gardener: gardener
        app3 = create_appointment date: :tomorrow_first_slot, gardener: gardener
        app1 = create_appointment date: :today_first_slot, gardener: gardener
        expect(Appointment.all).to eq [app2, app3, app1]

        expect(gardener.visits).to eq [app1, app2, app3]
      end
    end
  end

  describe 'Custom finders' do
    context '#gardeners' do
      it 'return first name ordered gardeners' do
        percy = FactoryGirl.create(:user, :gardener_p).contact
        allan = FactoryGirl.create(:user, :gardener_a).contact
        roger = FactoryGirl.create(:user, :client_r).contact
        expect(Contact.all).to eq [percy, allan, roger]

        expect(Contact.contacts_by_role('gardener')).to eq [allan, percy]
      end
    end

    context '#clients' do
      it 'return first name ordered clients' do
        roger = FactoryGirl.create(:user, :client_r).contact
        ann   = FactoryGirl.create(:user, :client_a).contact
        alan  = FactoryGirl.create(:user, :gardener_a).contact

        expect(Contact.all).to eq [roger, ann, alan]

        expect(Contact.contacts_by_role('client')).to eq [ann, roger]
      end

      it 'returns case insensitive ordering of clients' do
        roger = FactoryGirl.create(:user, :client_r).contact
        ann   = FactoryGirl.create(:user, :client_a).contact
        alan  = FactoryGirl.create(:user, :gardener_a).contact
        john  = FactoryGirl.build(:contact, :client_j, first_name: 'john')
        FactoryGirl.create(:user, :client_j, contact: john)
        expect(Contact.all).to eq [roger, ann, alan, john]

        expect(Contact.contacts_by_role('client')).to eq [ann, john, roger]
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
end
