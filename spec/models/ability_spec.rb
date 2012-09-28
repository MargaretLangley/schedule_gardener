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
      it ("can manage self")           { should be_able_to(:manage, user) }
      it ("can show self")             { should be_able_to(:show, user) }
      it ("can new self")              { should be_able_to(:new, user) }
      it ("can create self")           { should be_able_to(:create, user) }
      it ("can update self")           { should be_able_to(:update, user) }
      it ("cannot destroy self")       { should_not be_able_to(:destroy, user) }

      it ("can manage another user")   { should be_able_to(:manage, User.new) }
      it ("can show another user")     { should be_able_to(:show, User.new) }
      it ("can new another user")      { should be_able_to(:new, User.new) }
      it ("can create another user")   { should be_able_to(:create, User.new) }
      it ("can update another user")   { should be_able_to(:update, User.new) }
      it ("can destroy another user")  { should be_able_to(:destroy, User.new) }

     end

    context "client role" do
      let(:user) { FactoryGirl.create(:user, :client) }
      it ("can show self")   { should be_able_to(:show, user) }
      it ("can new self")    { should be_able_to(:new, user) }
      it ("can create self") { should be_able_to(:create, user) }
      it ("can edit self")   { should be_able_to(:edit, user) }
      it ("can update self") { should be_able_to(:update, user) }


      it ("cannot show another user")     { should_not be_able_to(:show,    User.new) }
      it ("cannot new another user")      { should_not be_able_to(:new,     User.new) }
      it ("cannot create another user")   { should_not be_able_to(:create,  User.new) }
      it ("cannot edit another user")     { should_not be_able_to(:edit,    User.new) }
      it ("cannot update another user")   { should_not be_able_to(:update,  User.new) }
      it ("cannot destroy another user")  { should_not be_able_to(:destroy, User.new) }
      it ("cannot manage another user")   { should_not be_able_to(:manage,  User.new) }
    end

  end

end