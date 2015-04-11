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

require 'spec_helper'
include ActionView::Helpers::DateHelper
require 'active_support/core_ext/time/calculations'

describe Event do
  # subject(:event) { FactoryGirl.build(:event, :tomorrow, title: "event_spec_subject") }
  # include_examples "All Built Objects", Event
end
