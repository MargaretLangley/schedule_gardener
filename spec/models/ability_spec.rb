require 'spec_helper'
require "cancan/matchers"

describe "abilities" do
  subject { ability }
  let(:ability){ Ability.new(user) }

  describe "Appointment" do
    let(:another_user) { FactoryGirl.create(:user, :client) }

    context "admin role" do
      let(:user) { FactoryGirl.create(:user, :admin) }

      it "can manage own appointments" do
        should be_able_to(:manage, Appointment.new(contact: user.contact) )
       end
      it "can manage appointment owned by another user" do
        should be_able_to(:manage, Appointment.new(contact: another_user.contact))
      end
    end

    context "client role" do
      let(:user) { FactoryGirl.create(:user, :client) }

      it "can manage own appointment" do
        should be_able_to(:manage, Appointment.new(contact: user.contact) )
      end
      it "cannot manage appointment owned by another user" do
        should_not be_able_to(:manage, Appointment.new(contact: another_user.contact) )
      end
    end

  end

  describe "User" do

    context "admin role" do
      let(:user) { FactoryGirl.create(:user, :admin) }
      it ("can manage self") { should be_able_to(:manage, user) }
      it ("can manage another user") { should be_able_to(:manage, User.new) }
     end

    context "client role" do
      let(:user) { FactoryGirl.create(:user, :client) }
      it ("can manage self") { should be_able_to(:manage, user) }
      it ("cannot manage another user") { should_not be_able_to(:manage, User.new) }
    end

  end

end