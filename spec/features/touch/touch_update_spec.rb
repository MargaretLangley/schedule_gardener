require 'spec_helper'

describe 'Touches#update' do
  before(:each) do
    Timecop.freeze(Time.zone.parse('2012-9-1 5:00'))
    visit_signin_and_login user_r
  end
  let(:user_r) { FactoryGirl.create(:user, :client_r) }

  subject { page }

  it 'displays' do
    touch_r = FactoryGirl.create(:touch, :tomorrow, contact: user_r.contact)
    visit edit_touch_path(touch_r)

    expect(current_path).to eq edit_touch_path(touch_r)
  end

  context 'with valid information' do
    before do
      touch_r = FactoryGirl.create(:touch, :tomorrow, contact: user_r.contact)
      visit edit_touch_path(touch_r)
      click_on('Update Contact Me')
    end

    it ('displays #update') { expect(current_path).to eq touches_path }
    it 'flash success' do
      should have_flash_success('Contact me was successfully updated.')
    end
  end
end
