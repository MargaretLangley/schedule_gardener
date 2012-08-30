class Event < ActiveRecord::Base
  attr_accessible :all_day, :description, :ends_at, :starts_at, :title

  validates :starts_at, :title, presence: true
  validates :title, length: { maximum: 50 }
  
  # need to override the json view to return what full_calendar is expecting.
  # http://arshaw.com/fullcalendar/docs/event_data/Event_Object/
  def as_json(options = {})
    {
      id: self.id,
      title: self.title,
      description: self.description || "",
      start: starts_at.rfc822,
      end: ends_at && ends_at.rfc822,
      allDay: self.all_day,
      recurring: false,
      url: Rails.application.routes.url_helpers.event_path(id),
      #:color => "red"
    }
    
  end

  def self.within_date_range(start_time, end_time)
    where('(starts_at BETWEEN ? AND ?) OR (ends_at BETWEEN ? AND ?)',
               Event.format_date(start_time), Event.format_date(end_time),
               Event.format_date(start_time), Event.format_date(end_time)
         )
  end
  
  def self.format_date(date_time)
    Time.at(date_time.to_i).to_formatted_s(:db)
  end
end
