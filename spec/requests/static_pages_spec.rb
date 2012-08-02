require 'spec_helper'

describe "Static pages" do

  subject { page }

  let(:user_first_name)  { "static_pages_user" }
  let(:user_phone_number) { "08734566" }

  shared_examples_for "all static pages" do
    it { should have_selector('h1',   text: heading) }
    it { should have_selector('title',text: full_title(page_title))}
  end

  describe "#Home page" do
    before { visit root_path}
    let(:heading)     { 'Garden Care'}
    let(:page_title)  {''}
    it_should_behave_like "all static pages"
    it { should_not have_selector('title', :text => '| Home') }

    describe "signed in users should be redirected away to users show page" do
      let(:user)  { FactoryGirl.create(:user,  first_name: user_first_name,  email: "#{user_first_name}@example.com", phone_number: user_phone_number ) }
      before do
        sign_in user 
        visit root_path
      end
      it { current_path.should eq user_path(user)}
    end
  end

  describe "#Help page" do
    before { visit help_path }
    let(:heading)     { 'Help'}
    let(:page_title)  {'Help'}
    it_should_behave_like "all static pages"
  end

  describe "#About page" do
    before { visit about_path }
    let(:heading)     { 'About Us'}
    let(:page_title)  {'About Us'}
    it_should_behave_like "all static pages"
  end

  describe "#Contact page" do
    before { visit contact_path }
    let(:heading)     { 'Contact'}
    let(:page_title)  {'Contact'}
    it_should_behave_like "all static pages"
  end


  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    page.should have_selector 'title', text: full_title('About Us')
    click_link "Help"
    page.should have_selector 'title', text: full_title('Help')
    click_link "Contact"
    page.should have_selector 'title', text: full_title('Contact')
    click_link "logo"
    click_link "Sign up now!"
    page.should have_selector 'title', text: full_title('Sign up')
    click_link "Garden Care"
    page.should have_selector 'title', text: full_title('')
  end
end