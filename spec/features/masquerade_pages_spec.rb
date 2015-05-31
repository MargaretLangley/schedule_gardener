# rubocop: disable Lint/UselessAssignment
require 'spec_helper'

describe 'Masquerade' do
  describe '#create' do
    it 'can masquerade' do
      client = FactoryGirl.create(:user, person: FactoryGirl.create(:person, :client_a, first_name: 'Adam'))
      admin = FactoryGirl.create(:user, person: FactoryGirl.create(:person, :admin, first_name: 'Zero'))
      visit_signin_and_login admin
      visit users_path

      first(:link, 'Masquerade').click

      expect(page).to have_link 'Stop Masquerading'
    end
  end

  describe '#destroy' do
    it 'can stop masquerade' do
      client = FactoryGirl.create(:user, person: FactoryGirl.create(:person, :client_a, first_name: 'Adam'))
      admin = FactoryGirl.create(:user, person: FactoryGirl.create(:person, :admin, first_name: 'Zero'))
      visit_signin_and_login admin
      visit users_path
      first(:link, 'Masquerade').click

      first(:link, 'Stop Masquerading').click

      expect(page).to have_content 'Stopped masquerading'
    end
  end
end
