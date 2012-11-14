class CreateAppointmentSlots < ActiveRecord::Migration
  def change
    create_table :appointment_slots do |t|
      t.string :time, null: false
      t.string :humanize_time, null: false
      t.integer :value, null: false

      t.timestamps
    end
  end
end
