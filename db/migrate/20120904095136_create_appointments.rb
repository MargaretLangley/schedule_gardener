class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.references :contact
      t.references :appointee
      t.string :title, null: false
      t.datetime :starts_at, null: false
      t.datetime :ends_at
      t.boolean :all_day, default: false
      t.text :description

      t.timestamps
    end
    add_index :appointments, :contact_id
    add_index :appointments, :appointee_id
  end
end
