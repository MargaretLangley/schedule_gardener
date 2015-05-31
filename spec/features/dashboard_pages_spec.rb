require 'spec_helper'

describe 'Dashboard#show' do
  context 'standard user' do
    let!(:user_r) do
      FactoryGirl.create(:user, person: FactoryGirl.create(:person, :client_r))
    end

    it 'displayed' do
      visit_signin_and_login user_r
      visit dashboard_path(user_r)

      expect(current_path).to eq dashboard_path(user_r)
    end
  end

  context 'Gardener' do
    let(:gardener_a) do
      FactoryGirl.create :user, person: FactoryGirl.create(:person, :gardener_a)
    end

    it 'displayed' do
      visit_signin_and_login gardener_a
      visit dashboard_path(gardener_a)

      expect(current_path).to eq dashboard_path(gardener_a)
    end
  end
end
