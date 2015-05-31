require 'spec_helper'

describe 'Static pages' do
  let(:user) do
    FactoryGirl.create(:user, person: FactoryGirl.create(:person, :client_j))
  end
  subject { page }

  context 'Home Page' do
    it 'redirect signed in users to a user specific page' do
      visit_signin_and_login user
      visit root_path
      expect(current_path).to eq dashboard_path(user)
    end
  end

  context 'Nav links' do
    before do
      visit root_path
    end

    context 'Home Page' do
      it 'links to sign up now' do
        click_link 'Sign up now!'
        expect(current_path).to eq signup_path
      end
    end

    context 'footer' do
      it 'links to about' do
        click_link 'About'
        expect(current_path).to eq about_path
      end
    end

    context 'header' do
      it 'links to logo' do
        click_link 'logo'
        expect(current_path).to eq root_path
      end
    end
  end
end
