require 'spec_helper'

describe UserMailer do
  describe 'password_reset' do
    let!(:mail) { UserMailer.password_reset(create_user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Password Reset')
    end

    it 'sent to' do
      expect(mail.to).to eq(['john.smith@example.com'])
    end

    it 'sent from' do
      expect(mail.from).to eq(['robot.gardener@test.example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('this email includes your user name and instructions to reset your password')
    end
  end

  def create_user
    person = FactoryGirl.create(:person, :client_j)
    FactoryGirl.create(:user, :resetting_password, person: person)
  end
end
