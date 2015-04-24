require 'spec_helper'

describe AppointmentIndexHelper do
  before { Timecop.travel Date.new(2013, 1, 1) }
  after { Timecop.return }

  it 'tell you if the appointment is today' do
    time_string = minimum_time_info appointment(starts_at: '2013-01-01 11:30:00',
                                                ends_at: '2013-01-01 13:00:00')

    expect(time_string).to eq 'Today'
  end

  it 'tells you if the appointment is due this week' do
    time_string = minimum_time_info appointment(starts_at: '2013-01-02 11:30:00',
                                                ends_at: '2013-01-02 13:00:00')

    expect(time_string).to eq 'Wed 11:30'
  end

  it 'tells you the date if the appointment is not due this week' do
    time_string = minimum_time_info appointment(starts_at: '2013-01-16 11:30:00',
                                                ends_at: '2013-01-16 13:00:00')

    expect(time_string).to eq '16 Jan 11:30'
  end

  def appointment(starts_at:, ends_at:)
    client = FactoryGirl.create :user, contact: FactoryGirl.create(:contact, :client_r)
    gardener = FactoryGirl.create :user,
                                  contact: FactoryGirl.create(:contact, :gardener_a)

    FactoryGirl.create(:appointment,
                       starts_at: starts_at,
                       ends_at: ends_at,
                       appointee: gardener.contact,
                       contact: client.contact)
  end
end
