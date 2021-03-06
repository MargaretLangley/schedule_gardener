require 'spec_helper'
require 'cancan/matchers'

describe 'abilities' do
  let(:guest_ability)    { Ability.new(nil) }
  let(:client_ability)   { Ability.new(client) }
  let(:gardener_ability) { Ability.new(gardener) }
  let(:admin_ability)    { Ability.new(admin) }

  let(:admin)          { FactoryGirl.create(:user, :admin) }
  let(:another_client) { FactoryGirl.create(:person, :client_a).user }
  let(:client)         { FactoryGirl.create(:person, :client_j).user }
  let(:gardener)       { FactoryGirl.create(:person, :gardener_a).user }

  shared_examples_for 'can_manage_user' do |ability, user|
    it ('can show')     { expect(ability).to be_able_to(:show, user) }
    it ('can new')      { expect(ability).to be_able_to(:new, user) }
    it ('can create')   { expect(ability).to be_able_to(:create, user) }
    it ('can edit')     { expect(ability).to be_able_to(:edit, user) }
    it ('can update')   { expect(ability).to be_able_to(:update, user) }
    it ('can destroy')  { expect(ability).to be_able_to(:destroy, user) }
    it ('can manage')   { expect(ability).to be_able_to(:manage, user) }
  end

  describe 'User' do
    context 'guest role' do
      subject { guest_ability }

      context 'self' do
        it ('can show')   { should_not be_able_to(:show, User.new) }
        it ('can new')    { should be_able_to(:new, User.new) }
        it ('can create') { should be_able_to(:create, User.new) }
        it ('can edit')   { should_not be_able_to(:edit, User.new) }
        it ('can update') { should_not be_able_to(:update, User.new) }
      end

      context 'another user' do
        it ('cannot index users')           { should_not be_able_to(:index,   User.new) }
        it ('cannot show')     { should_not be_able_to(:show,    User.new) }
        # Don't know why they shouldn't but feel uneasy that they can create!
        it ('cannot new')      { should be_able_to(:new,     User.new) }
        it ('cannot create')   { should be_able_to(:create,  User.new) }
        it ('cannot edit')     { should_not be_able_to(:edit,    User.new) }
        it ('cannot update')   { should_not be_able_to(:update,  User.new) }
        it ('cannot destroy')  { should_not be_able_to(:destroy, User.new) }
        it ('cannot manage')   { should_not be_able_to(:manage,  User.new) }
      end
    end

    context 'client role' do
      subject { client_ability }

      context 'self' do
        it ('cannot index users')  { should_not be_able_to(:index,   client) }
        it ('can show')       { should be_able_to(:show,    client) }
        it ('can new')        { should be_able_to(:new,     client) }
        it ('can create')     { should be_able_to(:create,  client) }
        it ('can edit')       { should be_able_to(:edit,    client) }
        it ('can update')     { should be_able_to(:update,  client) }
        it ('can destroy')    { should_not be_able_to(:destroy, client) }
        it ('cannot manage')  { should_not be_able_to(:manage,  client) }
      end

      context 'another client' do
        it ('cannot show')     { should_not be_able_to(:show,    User.new) }
        it ('cannot new')      { should_not be_able_to(:new,     User.new) }
        it ('cannot create')   { should_not be_able_to(:create,  User.new) }
        it ('cannot edit')     { should_not be_able_to(:edit,    User.new) }
        it ('cannot update')   { should_not be_able_to(:update,  User.new) }
        it ('cannot destroy')  { should_not be_able_to(:destroy, User.new) }
        it ('cannot manage')   { should_not be_able_to(:manage,  User.new) }
      end
    end

    context 'gardener role' do
      subject { gardener_ability }

      context 'self' do
        it ('can index users') { should be_able_to(:index,   gardener) }
        it ('can show')        { should be_able_to(:show,    gardener) }
        it ('can new')         { should be_able_to(:new,     gardener) }
        it ('can create')      { should be_able_to(:create,  gardener) }
        it ('can edit')        { should be_able_to(:edit,    gardener) }
        it ('can update')      { should be_able_to(:update,  gardener) }
        it ('can destroy')     { should_not be_able_to(:destroy, gardener) }
        it ('can manage')      { should_not be_able_to(:manage,  gardener) }
      end

      context 'client' do
        it ('cannot show')     { should be_able_to(:show,    client) }
        it ('cannot new')      { should be_able_to(:new,     client) }
        it ('cannot create')   { should be_able_to(:create,  client) }
        it ('cannot edit')     { should be_able_to(:edit,    client) }
        it ('cannot update')   { should be_able_to(:update,  client) }
        it ('cannot destroy')  { should_not be_able_to(:destroy, client) }
        it ('cannot manage')   { should_not be_able_to(:manage,  client) }
      end
    end

    context 'admin role' do
      subject { admin_ability }

      context 'self' do
        it ('can index users')      { should be_able_to(:index, admin) }
        it ('can show')             { should be_able_to(:show, admin) }
        it ('can new')              { should be_able_to(:new, admin) }
        it ('can create')           { should be_able_to(:create, admin) }
        it ('can update')           { should be_able_to(:update, admin) }
        it ('cannot destroy')       { should_not be_able_to(:destroy, admin) }
        it ('can manage')           { should be_able_to(:manage, admin) }
      end

      context 'another user' do
        it_should_behave_like 'can_manage_user', Ability.new(FactoryGirl.create(:user, :admin)), User.new
      end
    end
  end

  describe 'Appointment' do
    context 'client role' do
      subject { client_ability }

      it 'can manage own appointment' do
        should be_able_to(:manage, Appointment.new(person: client.person))
      end
      it 'cannot manage appointment owned by another user' do
        should_not be_able_to(:manage, Appointment.new(person: another_client.person))
      end
    end

    context 'gardener role' do
      subject { gardener_ability }

      it 'can manage own appointments' do
        should be_able_to(:manage, Appointment.new(person: gardener.person))
      end
      it 'can manage appointment owned by another user' do
        should be_able_to(:manage, Appointment.new(person: another_client.person))
      end
    end

    context 'admin role' do
      subject { admin_ability }

      it 'can manage own appointments' do
        should be_able_to(:manage, Appointment.new(person: admin.person))
      end
      it 'can manage appointment owned by another user' do
        should be_able_to(:manage, Appointment.new(person: another_client.person))
      end
    end
  end

  describe 'Contact' do
    context 'client role' do
      subject { client_ability }

      it 'can manage own contact' do
        should be_able_to(:manage, Contact.new(person: client.person))
      end
      it 'cannot manage appointment owned by another user' do
        should_not be_able_to(:manage, Contact.new(person: another_client.person))
      end
    end

    context 'gardener role' do
      subject { gardener_ability }

      it 'can manage own appointments' do
        should be_able_to(:manage, Contact.new(person: gardener.person))
      end
      it 'can manage appointment owned by another user' do
        should be_able_to(:manage, Contact.new(person: another_client.person))
      end
    end

    context 'admin role' do
      subject { admin_ability }

      it 'can manage own appointments' do
        should be_able_to(:manage, Contact.new(person: admin.person))
      end
      it 'can manage appointment owned by another user' do
        should be_able_to(:manage, Contact.new(person: another_client.person))
      end
    end
  end

  describe 'Masquerade' do
    context 'client role' do
      subject { client_ability }
      it 'cannot new masquerade' do
        should_not be_able_to(:new, :masquerade)
      end
      it 'can destroy masquerade' do
        should be_able_to(:destroy, :masquerade)
      end
    end

    context 'gardener role' do
      subject { gardener_ability }

      it 'cannot new masquerade' do
        should_not be_able_to(:new, :masquerade)
      end
      it 'can destroy masquerade' do
        should be_able_to(:destroy, :masquerade)
      end
    end

    context 'admin role' do
      subject { admin_ability }

      it 'can new masquerade' do
        should be_able_to(:new, :masquerade)
      end
      it 'can destroy masquerade' do
        should be_able_to(:destroy, :masquerade)
      end
    end
  end
end
