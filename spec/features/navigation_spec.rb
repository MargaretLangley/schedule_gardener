require 'spec_helper'

describe 'Navigation' do
  subject { page }

  context 'standard user' do
    let!(:user) do
      FactoryGirl.create(:user, contact: FactoryGirl.create(:contact, :client_r))
    end

    it 'hides users' do
      visit_signin_and_login user
      visit dashboard_path(user)

      should_not have_link('Users', href: users_path)
    end
  end

  context 'Gardener' do
    let(:gardener) do
      FactoryGirl.create :user, contact: FactoryGirl.create(:contact, :gardener_a)
    end

    it 'displays users' do
      visit_signin_and_login gardener
      visit dashboard_path(gardener)

      should have_link('Users', href: users_path)
    end
  end

  context 'Admin' do
    let(:admin) do
      FactoryGirl.create :user, contact: FactoryGirl.create(:contact, :admin)
    end

    it 'displays users' do
      visit_signin_and_login admin
      visit dashboard_path(admin)

      should have_link('Users', href: users_path)
    end
  end
end
