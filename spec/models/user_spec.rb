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
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

# cut and paste into terminal
# User.new(first_name: "Example", last_name: "User", email: "user@example.com", password: "foobar", password_confirmation: "foobar", home_phone: "0121-308-1439")

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

  context 'Custom finders' do
    context '#find_by_email' do
      user1 = user2 = user3 = nil

      before(:all) do
        user1 =	FactoryGirl.create(:user, :client_j)
        user2 =	FactoryGirl.create(:user, :client_a)
        user3 =	FactoryGirl.create(:user, :client_r)

        expect(User.all).to match [user1, user2, user3]
      end

      after(:all) { User.destroy_all;  }

      it 'return user by email' do
        expect(User.find_by_email('ann.abbey@example.com')).to eq user2
      end

      it 'empty email should not return a user' do
        expect(User.find_by_email('')).to eq nil
      end
    end

    context '#search_ordered' do
      john = roger = ann = nil

      before(:all) do
        john = FactoryGirl.create(:user, :client_j)
        roger = FactoryGirl.create(:user, :client_r)
        ann = FactoryGirl.create(:user, :client_a)

        expect(User.all).to match [john, roger, ann]
      end
      after(:all) { User.destroy_all }

      it 'empty search should return users' do
        expect(User.search_ordered).to eq [ann, john, roger]
      end

      it 'unique name match' do
        expect(User.search_ordered('John')).to eq [john]
      end

      it 'match multiple' do
        expect(User.search_ordered('Smi')).to eq [john, roger]
      end

      it 'case insenstive' do
        expect(User.search_ordered('s')).to eq [john, roger]
      end

      it 'should match full name' do
        expect(User.search_ordered('John Smith')).to eq [john]
      end
    end
  end

  describe 'Association' do
    it { should have_one(:contact).dependent(:destroy) }
  end
end
