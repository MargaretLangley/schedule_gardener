require 'spec_helper'

describe 'Touches' do
  before(:each) do
    Timecop.freeze(Time.zone.parse('1/9/2012 5:00'))
    Capybara.reset_sessions!
    visit_signin_and_login user_r
  end
  let(:user_r) { FactoryGirl.create(:user, :client_r) }
  let!(:touch_r) { FactoryGirl.create(:touch, :tomorrow, contact: user_r.contact) }
  let(:gardener_a) { FactoryGirl.create(:user, :gardener_a) }

  subject { page }

  context '#index' do
    touch_a = nil
    before(:each) do
      touch_a = FactoryGirl.create(:touch, :client_j, :today, by_phone: true)
    end

    context 'standard user' do
      before { visit touches_path }
      it ('displayed') { current_path.should eq touches_path }
      it ('own listed') { should have_content 'Roger Smith' }
      it ('others not listed') { should_not have_content 'John Smith' }
      it 'edits touch' do
        click_on('Edit')
        current_path.should eq edit_touch_path(touch_r)
      end

      it ('deletes touch') { expect { click_on('Delete') }.to change(Touch, :count).by(-1) }
    end

    context 'Gardener' do
      before do
        visit_signin_and_login gardener_a
        visit touches_path
      end

      it ('displayed') { current_path.should eq touches_path }
      it ('both listed') { should have_content 'Roger Smith' }
      it ('both listed') { should have_content 'John Smith' }

      it 'edits touch' do
        first(:link, 'Edit').click
        current_path.should eq edit_touch_path(touch_a)
      end

      it ('deletes touch') { expect { first(:link, 'Delete').click }.to change(Touch, :count).by(-1) }
    end
  end

  context '#new' do
    before(:each) {  visit new_touch_path }

    context 'standard user' do
      it ('displayed') { current_path.should eq new_touch_path }
      it ('has client missing') { should_not have_selector('#touch_contact_id') }
      it 'can cancel' do
        click_on('Cancel')
        current_path.should eq touches_path
      end

      context 'hides gardener only content' do
        it ('by phone')  { should_not have_content 'By phone' }
        it ('by visit')  { should_not have_content 'By visit' }
        it ('completed')  { should_not have_content 'Completed' }
      end

      context 'with valid information' do
        it ('adds touch') { expect { click_on('Contact Me') }.to change(Touch, :count).by(1) }

        context 'on create' do
          before { click_on('Contact Me') }
          it ('displays #index') { current_path.should eq touches_path }
          it ('flash success') { should have_flash_success ('Contact me was successfully created.') }
        end
      end

      context 'with invalid information' do
        before do
          fill_in 'Contact from', with: '1 Aug 2012'
        end

        it ('fails') { expect { click_on('Contact Me') }.to change(Touch, :count).by(0) }

        it 'flash error' do
          click_on('Contact Me')
          should have_content('error')
        end
      end
    end

    context 'gardener' do
      before do
        visit_signin_and_login gardener_a
        visit new_touch_path
      end

      context 'has gardener only contnet' do
        it ('by phone')  { should have_content 'By phone' }
        it ('by visit')  { should have_content 'By visit' }
        it ('completed')  { should have_content 'Completed' }
      end

      context 'with valid information' do
        before { check 'By phone' }
        it ('adds touch') { expect { click_on('Contact Me') }.to change(Touch, :count).by(1) }
      end
    end
  end

  context '#edit' do
    before(:each) {  visit edit_touch_path(touch_r) }
    it ('displays') { current_path.should eq edit_touch_path(touch_r) }
  end

  context '#update' do
    before { visit edit_touch_path(touch_r) }

    context 'with valid information' do
      before { click_on('Update Contact Me') }

      context 'on update' do
        it ('displays #update') { current_path.should eq touches_path }
        it ('flash success') { should have_flash_success('Contact me was successfully updated.') }
      end
    end
  end
end
