# == Schema Information
#
# Table name: touches
#
#  id            :integer          not null, primary key
#  contact_id    :integer
#  by_email      :boolean
#  by_phone      :boolean
#  by_visit      :boolean
#  visit_at      :datetime
#  touch_from    :datetime
#  between_start :datetime
#  between_end   :datetime
#  completed     :boolean
#  description   :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Touch < ActiveRecord::Base
  belongs_to :contact
  attr_accessible :between_end, :between_start, :contact, :by_email, :by_phone, :by_visit, :description, :touch_from, :visit_at
  validates_datetime :between_start, on_or_after: :today, on_or_before: :this_date_next_year
  validates_datetime :between_end, on_or_after: :between_start, on_or_before: :this_date_next_year
  validates_datetime :touch_from, on_or_after: :today, on_or_before: :this_date_next_year
  validates_datetime :visit_at, on_or_after: :today, on_or_before: :this_date_next_year

  after_initialize :initialize_record

  def initialize_record
    self.by_email ||= false
    self.by_phone ||= false
    self.by_visit ||= false
    self.visit_at ||= Time.zone.now.beginning_of_day
    self.touch_from ||= Time.zone.now.beginning_of_day
    self.between_start ||= Time.zone.now.beginning_of_day
    self.between_end ||= Time.zone.now.beginning_of_day + 1.year
    self.description ||= ''
    self.completed ||= false
  end


end
