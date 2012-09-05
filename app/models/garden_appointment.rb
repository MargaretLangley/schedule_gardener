class GardenAppointment < ActiveRecord::Base

  attr_accessible :event, :gardener, :garden, :payee

  #validates :gardener, :payee, :garden, :event, presence: true 

  belongs_to :gardener, class_name: "Contact", :foreign_key => "gardener_id"
  belongs_to :payee, class_name: "Contact", :foreign_key => "payee_id"                  
  belongs_to :garden
  belongs_to :event
end
