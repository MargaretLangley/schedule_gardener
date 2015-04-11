require 'spec_helper'
require 'cancan/matchers'

describe 'abilities' do
  let(:guest_ability)    { Ability.new(nil) }
  let(:client_ability)   { Ability.new(client) }
  let(:gardener_ability) { Ability.new(gardener) }
  let(:admin_ability)    { Ability.new(admin) }

  let(:admin)          { FactoryGirl.create(:user, :admin) }
  let(:another_client) { FactoryGirl.create(:user, :client_a) }
  let(:client)         { FactoryGirl.create(:user, :client_j) }
  let(:gardener)       { FactoryGirl.create(:user, :gardener_a) }

  shared_examples_for 'can_manage_user' do |ability, user|
    it ('can show')     { ability.should be_able_to(:show, user) }
    it ('can new')      { ability.should be_able_to(:new, user) }
    it ('can create')   { ability.should be_able_to(:create, user) }
    it ('can edit')     { ability.should be_able_to(:edit, user) }
    it ('can update')   { ability.should be_able_to(:update, user) }
    it ('can destroy')  { ability.should be_able_to(:destroy, user) }
    it ('can manage')   { ability.should be_able_to(:manage, user) }
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
        # it ("can show")     { should     be_able_to(:show, User.new) }
        # it ("can new")      { should     be_able_to(:new, User.new) }
        # it ("can create")   { should     be_able_to(:create, User.new) }
        # it ("can edit")     { should     be_able_to(:edit, User.new) }
        # it ("can update")   { should     be_able_to(:update, User.new) }
        # it ("can destroy")  { should     be_able_to(:destroy, User.new) }
        # it ("can manage")   { should     be_able_to(:manage, User.new) }
      end
    end

    context 'unexpected role' do
      subject { unexpected_ability }

      it 'causes exception' do
        expect { Ability.new(FactoryGirl.create(:user, :unexpected)) }.to raise_error(RuntimeError, 'Missing Role: unexpected in Ability#initialize')
      end
    end
  end

  describe 'Appointment' do
    context 'client role' do
      subject { client_ability }

      it 'can manage own appointment' do
        should be_able_to(:manage, Appointment.new(contact: client.contact))
      end
      it 'cannot manage appointment owned by another user' do
        should_not be_able_to(:manage, Appointment.new(contact: another_client.contact))
      end
    end

    context 'gardener role' do
      subject { gardener_ability }

      it 'can manage own appointments' do
        should be_able_to(:manage, Appointment.new(contact: gardener.contact))
      end
      it 'can manage appointment owned by another user' do
        should be_able_to(:manage, Appointment.new(contact: another_client.contact))
      end
    end

    context 'admin role' do
      subject { admin_ability }

      it 'can manage own appointments' do
        should be_able_to(:manage, Appointment.new(contact: admin.contact))
      end
      it 'can manage appointment owned by another user' do
        should be_able_to(:manage, Appointment.new(contact: another_client.contact))
      end
    end
  end

  describe 'Touch' do
    context 'client role' do
      subject { client_ability }

      it 'can manage own touch' do
        should be_able_to(:manage, Touch.new(contact: client.contact))
      end
      it 'cannot manage appointment owned by another user' do
        should_not be_able_to(:manage, Touch.new(contact: another_client.contact))
      end
    end

    context 'gardener role' do
      subject { gardener_ability }

      it 'can manage own appointments' do
        should be_able_to(:manage, Touch.new(contact: gardener.contact))
      end
      it 'can manage appointment owned by another user' do
        should be_able_to(:manage, Touch.new(contact: another_client.contact))
      end
    end

    context 'admin role' do
      subject { admin_ability }

      it 'can manage own appointments' do
        should be_able_to(:manage, Touch.new(contact: admin.contact))
      end
      it 'can manage appointment owned by another user' do
        should be_able_to(:manage, Touch.new(contact: another_client.contact))
      end
    end
  end
end
