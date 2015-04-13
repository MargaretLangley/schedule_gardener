require 'spec_helper'

describe 'Touches#index' do
  before(:each) { Timecop.freeze(Time.zone.parse('2012-9-1 5:00')) }
  subject { page }

  context 'standard user' do
    context 'displays' do
      before do
        visit_signin_and_login FactoryGirl.create(:user, :client_r)

        FactoryGirl.create(:touch, :client_j, :tomorrow, by_phone: true)
        visit touches_path
      end
      it ('is on page') { expect(page.title).to eq 'Garden Care | Contact Me' }
      it ('own listed') { should have_content 'Roger Smith' }
      it ('others not listed') { should_not have_content 'John Smith' }
    end

    it 'deletes touch' do
      user_r = FactoryGirl.create(:user, :client_r)
      FactoryGirl.create(:touch, :tomorrow, contact: user_r.contact)

      visit_signin_and_login user_r
      visit touches_path

      expect { click_on('Delete') }.to change(Touch, :count).by(-1)
    end
  end

  context 'Gardener' do
    touch_a = nil
    before do
      visit_signin_and_login FactoryGirl.create(:user, :gardener_a)

      touch_a = FactoryGirl.create(:touch, :client_j, :tomorrow, by_phone: true)
      visit touches_path
    end

    it ('displayed') { expect(page.title).to eq 'Garden Care | Contact Me' }
    it 'lists gardener and users' do
      should have_content 'Alan Titmarsh'
      should have_content 'John Smith'
    end

    it 'edits touch' do
      first(:link, 'Edit').click
      expect(current_path).to eq edit_touch_path(touch_a)
    end

    it 'deletes touch' do
      expect { first(:link, 'Delete').click }.to change(Touch, :count).by(-1)
    end
  end
end
