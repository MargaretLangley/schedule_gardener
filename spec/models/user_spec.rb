# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  password_digest        :string(255)      not null
#  remember_token         :string(255)
#  admin                  :boolean          default(FALSE)
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#  email_verified         :boolean          default(FALSE)
#  verify_email_token     :string(255)
#  verify_email_sent_at   :datetime
#  created_at             :datetime
#  updated_at             :datetime
#

require 'spec_helper'

describe User do
  subject(:user) { FactoryGirl.build(:user) }

  include_examples 'All Built Objects', User

  context 'validate factory' do
    it { should_not be_admin }
  end

  context 'validations' do
    [:password].each do |validate_attr|
      it { should validate_length_of(validate_attr).is_at_least(6) }
    end

    it 'invalid with different password and confirmation' do
      user.password_confirmation = 'mismatched'
      should_not be_valid
    end
  end

  context '#toggle admin' do
    before { user.toggle(:admin) }
    it { should be_admin }
  end

  context '#authenticate' do
    it 'with valid password succeeds' do
      expect(user.authenticate(user.password)).to be_truthy
    end

    it 'with invalid password fails' do
      expect(user.authenticate('InvalidPassword')).to be false
    end
  end

  describe 'remember token' do
    before { user.save }
    it 'has remember_token which is not blank' do
      expect(user.remember_token).to_not be_blank
    end
  end

  describe 'Custom finders' do
    def create_user(trait:)
      contact = FactoryGirl.create(:contact, trait)
      FactoryGirl.create(:user, contact: contact)
    end

    describe '#find_by_email' do
      it 'should create in order' do
        user1 = FactoryGirl.create(:contact, :client_j).user
        user2 = FactoryGirl.create(:contact, :client_a).user
        user3 = FactoryGirl.create(:contact, :client_r).user

        expect(User.all).to match [user1, user2, user3]
      end

      it 'return user by email' do
        FactoryGirl.create(:contact, :client_j)
        user2 = FactoryGirl.create(:contact, :client_a).user
        FactoryGirl.create(:contact, :client_r)

        expect(User.find_by_email('ann.abbey@example.com')).to eq user2
      end

      it 'empty email should not return a user' do
        FactoryGirl.create(:contact, :client_j)
        FactoryGirl.create(:contact, :client_a)
        FactoryGirl.create(:contact, :client_r)

        expect(User.find_by_email('')).to eq nil
      end
    end

    describe '#search_ordered' do
      john = roger = ann = nil

      before(:each) do
        john = FactoryGirl.create(:contact, :client_j).user
        roger = FactoryGirl.create(:contact, :client_r).user
        ann = FactoryGirl.create(:contact, :client_a).user
      end

      it 'should create in order' do
        expect(User.all).to match [john, roger, ann]
      end

      it 'empty search should return users' do
        expect(User.search_ordered).to eq [ann, john, roger]
      end

      it 'unique name match' do
        expect(User.search_ordered('John')).to eq [john]
      end

      it 'match multiple' do
        expect(User.search_ordered('Smi')).to eq [john, roger]
      end

      it 'case insensitive' do
        expect(User.search_ordered('s')).to eq [john, roger]
      end

      it 'should match full name' do
        expect(User.search_ordered('John Smith')).to eq [john]
      end
    end
  end
end
