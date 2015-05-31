# == Schema Information
#
# Table name: persons
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

describe Person do
  before { Timecop.freeze(Time.zone.parse('1/9/2012 8:00')) }
  subject(:person) { FactoryGirl.build(:person, :client_r) }

  include_examples 'All Built Objects', Person

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
        person.email = mixed_case_email
        person.save
        expect(person.reload.email).to eq mixed_case_email.downcase
      end

      it 'with bad format are invalid' do
        should_not allow_value('foobar_baz.com').for(:email)
      end
    end
  end

  describe 'ordering' do
    def create_appointment(date:, person: nil, gardener: nil)
      person = FactoryGirl.build(:person, :client_r) unless person
      gardener = FactoryGirl.build(:person, :gardener_a) unless gardener
      FactoryGirl.create(:appointment,
                         date,
                         person: person,
                         appointee: gardener)
    end

    describe '#appointments' do
      it 'returns expected appointments ordered by date' do
        app2 = create_appointment(date: :today_fourth_slot, person: person)
        app3 = create_appointment(date: :tomorrow_first_slot, person: person)
        app1 = create_appointment(date: :today_first_slot, person: person)
        expect(Appointment.all).to eq [app2, app3, app1]

        expect(person.appointments).to eq [app1, app2, app3]
      end
    end

    describe '#visits' do
      it 'returns expected visits ordered by date' do
        gardener = FactoryGirl.build(:person, :gardener_a)
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
        percy = FactoryGirl.create(:person, :gardener_p)
        allan = FactoryGirl.create(:person, :gardener_a)
        roger = FactoryGirl.create(:person, :client_r)
        expect(Person.all).to eq [percy, allan, roger]

        expect(Person.by_role('gardener')).to eq [allan, percy]
      end
    end

    context '#clients' do
      it 'return first name ordered clients' do
        roger = FactoryGirl.create(:person, :client_r)
        ann   = FactoryGirl.create(:person, :client_a)
        alan  = FactoryGirl.create(:person, :gardener_a)

        expect(Person.all).to eq [roger, ann, alan]

        expect(Person.by_role('client')).to eq [ann, roger]
      end

      it 'returns case insensitive ordering of clients' do
        roger = FactoryGirl.create(:person, :client_r)
        ann   = FactoryGirl.create(:person, :client_a)
        alan  = FactoryGirl.create(:person, :gardener_a)
        john  = FactoryGirl.create(:person, :client_j, first_name: 'john')
        expect(Person.all).to eq [roger, ann, alan, john]

        expect(Person.by_role('client')).to eq [ann, john, roger]
      end
    end
  end

  it 'full_name is correct' do
    expect(person.full_name).to eq 'Roger Smith'
  end

  context '#home_phone' do
    it 'only save numerics' do
      person.home_phone = '(0181).,;.300-1234'
      expect(person.home_phone).to eq '01813001234'
    end
  end

  context '#mobile' do
    it 'only save numerics' do
      person.mobile = '(0181).,;.300-1234'
      expect(person.mobile).to eq '01813001234'
    end
  end
end
