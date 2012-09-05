class CreateGardenAppointments < ActiveRecord::Migration
  def change
    create_table :garden_appointments do |t|
      t.references :gardener
      t.references :payee
      t.references :garden
      t.references :event

      t.timestamps
    end
    add_index :garden_appointments, :gardener_id
    add_index :garden_appointments, :payee_id
    add_index :garden_appointments, :garden_id
    add_index :garden_appointments, :event_id
  end
end
