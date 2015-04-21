require 'spec_helper'

describe 'Touches#update' do
  before(:each) do
    Timecop.freeze(Time.zone.parse('2012-9-1 5:00'))
    visit_signin_and_login user
  end
  let(:user) do
    FactoryGirl.create(:user, contact: FactoryGirl.create(:contact, :client_r))
  end

  subject { page }

  it 'displays' do
    touch = FactoryGirl.create(:touch, :tomorrow, contact: user.contact)
    visit edit_touch_path(touch)

    expect(current_path).to eq edit_touch_path(touch)
  end

  context 'with valid information' do
    before do
      touch = FactoryGirl.create(:touch, :tomorrow, contact: user.contact)
      visit edit_touch_path(touch)
      click_on('Update Contact Me')
    end

    it ('displays #update') { expect(current_path).to eq touches_path }
    it 'flash success' do
      should have_flash_success('Contact me was successfully updated.')
    end
  end
end
