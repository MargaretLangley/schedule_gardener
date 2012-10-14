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

class Event
  include ActiveAttr::Model
  include ActiveAttr::MassAssignment

  attr_accessible :all_day, :description, :ends_at, :starts_at, :title
  attribute :id, type: Integer
  attribute :all_day, type: Boolean
  attribute :description, type: String
  attribute :ends_at, type: DateTime
  attribute :starts_at, type: DateTime
  attribute :title, type: String

  validates :starts_at, :title, presence: true
  validates :title, length: { maximum: 50 }

end
