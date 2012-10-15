# == Schema Information
#
# Table name: appointments
#
#  id           :integer          not null, primary key
#  contact_id   :integer
#  appointee_id :integer
#  title        :string(255)      not null
#  starts_at    :datetime         not null
#  ends_at      :datetime
#  all_day      :boolean          default(FALSE)
#  description  :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#



class Appointment < ActiveRecord::Base

  attr_accessible :all_day, :appointee_id, :contact, :contact_id, :description, :ends_at, :starts_at

  validates :appointee, :contact, :starts_at, :ends_at, presence: true

  belongs_to :contact, class_name: "Contact", foreign_key: 'contact_id'
  belongs_to :appointee, class_name: "Contact", foreign_key: 'appointee_id'

  def title
    contact.first_name
  end

  def starts_at_two
    (read_attribute(:starts_at) || DateTime.now()).to_date
    #due_at.to_s(:db)
  end

  # def due_at_string=(due_at_str)
  #   self.due_at = Time.parse(due_at_str)
  # end

  def self.after_now()
     where { starts_at > DateTime.now }
  end

  def self.in_time_range(time_range)
      where { (starts_at.in time_range) | (ends_at.in time_range) }
  end


  def to_event
    event = Event.new(all_day: all_day, description: description,
                      ends_at: ends_at, starts_at: starts_at, title: title)
    event.id = id
    event
  end

end
