require 'spec_helper'

describe 'Dashboard#show' do
  context 'standard user' do
    let!(:user_r) do
      FactoryGirl.create(:user, contact: FactoryGirl.create(:contact, :client_r))
    end
    before do
      visit_signin_and_login user_r
      visit dashboard_path(user_r)
    end
    it ('displayed') { expect(current_path).to eq dashboard_path(user_r) }
  end

  context 'Gardenerr' do
    let(:gardener_a) { FactoryGirl.create(:user, :gardener_a) }
    before do
      visit_signin_and_login gardener_a
      visit dashboard_path(gardener_a)
    end

    it ('displayed') { expect(current_path).to eq dashboard_path(gardener_a) }
  end
end
