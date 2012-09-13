# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  title       :string(255)      not null
#  starts_at   :datetime         not null
#  ends_at     :datetime
#  all_day     :boolean          default(FALSE)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Event < ActiveRecord::Base
  attr_accessible :all_day, :description, :ends_at, :starts_at, :title

  validates :starts_at, :title, presence: true
  validates :title, length: { maximum: 50 }

  has_many  :appointments, dependent: :destroy


  # as_json - returns a hash representing the model
  # need to override the json view to return what full_calendar is expecting.
  # http://arshaw.com/fullcalendar/docs/event_data/Event_Object/
  def as_json(options = {})
    {
      id: self.id,
      title: self.title,
      description: self.description + " aj " || "",
      start: starts_at.rfc822,
      end: ends_at && ends_at.rfc822,
      allDay: self.all_day,
      recurring: false,
      url: Rails.application.routes.url_helpers.event_path(id),
      #:color => "red"
    }

  end

  def self.in_time_range(time_range)
      where { (starts_at.in time_range) | (ends_at.in time_range) }
  end

end
