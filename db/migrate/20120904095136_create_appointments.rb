class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.references :contact
      t.references :appointee
      t.references :event

      t.timestamps
    end
    add_index :appointments, :contact_id
    add_index :appointments, :appointee_id
    add_index :appointments, :event_id
  end
end
