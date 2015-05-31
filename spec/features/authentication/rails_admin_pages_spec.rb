require 'spec_helper'

describe 'RailsAdmin Authentication' do
  subject { page }

  describe 'allows' do
    it 'admin user to enter' do
      admin = FactoryGirl.create(:person, :admin).user
      visit_signin_and_login(admin)
      visit rails_admin_path

      expect(current_path).to eq rails_admin_path
    end
  end

  describe 'redirects' do
    it 'unauthorized users to root' do
      visit rails_admin_path

      expect(current_path).to eq '/'
    end

    it 'standard users to root' do
      client = FactoryGirl.create(:person, :client_j).user
      visit_signin_and_login(client)
      visit rails_admin_path

      expect(current_path).to eq root_path
    end

    it 'gardeners to root' do
      gardener = FactoryGirl.create(:person, :gardener_a).user
      visit_signin_and_login(gardener)
      visit rails_admin_path

      expect(current_path).to eq root_path
    end
  end
end
