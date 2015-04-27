require 'spec_helper'

describe 'Touches#index' do
  before(:each) { Timecop.freeze(Time.zone.parse('2012-9-1 5:00')) }
  subject { page }

  context 'standard user' do
    context 'displays' do
      before do
        contact = FactoryGirl.create(:contact,
                                     first_name: 'Ann',
                                     last_name: 'Abbey')
        visit_signin_and_login FactoryGirl.create(:user, contact: contact)

        FactoryGirl.create(:touch, :client_j, :tomorrow, by_phone: true)
        visit touches_path
      end
      it ('is on page') { expect(page.title).to eq 'Garden Care | Contact Me' }
      it ('own listed') { should have_content 'Ann Abbey' }
      it ('others not listed') { should_not have_content 'John Smith' }
    end

    it 'deletes touch' do
      contact = FactoryGirl.create(:contact)
      user = FactoryGirl.create(:user, contact: contact)
      FactoryGirl.create(:touch, :tomorrow, contact: user.contact)

      visit_signin_and_login user
      visit touches_path

      expect { click_on('Delete') }.to change(Touch, :count).by(-1)
    end
  end

  context 'Gardener' do
    touch = nil
    before do
      gardener = FactoryGirl
                 .create(:user, contact: FactoryGirl.create(:contact, :gardener_a)).contact
      client = FactoryGirl
               .create(:user, contact: FactoryGirl.create(:contact, :client_j)).contact
      visit_signin_and_login gardener.user

      touch = FactoryGirl.create(:touch, :tomorrow, contact: client, appointee: gardener, by_phone: true)
      visit touches_path
    end

    it ('displayed') { expect(page.title).to eq 'Garden Care | Contact Me' }
    it 'lists gardener and users' do
      should have_content 'Alan Titmarsh'
      should have_content 'John Smith'
    end

    it 'edits touch' do
      first(:link, 'Edit').click
      expect(current_path).to eq edit_touch_path(touch)
    end

    it 'deletes touch' do
      expect { first(:link, 'Delete').click }.to change(Touch, :count).by(-1)
    end
  end
end
