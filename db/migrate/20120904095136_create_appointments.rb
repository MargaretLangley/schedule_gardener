class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.belongs_to :person, null: false, index: true
      t.belongs_to :appointee, null: false, index: true
      t.datetime :starts_at, null: false
      t.datetime :ends_at, null: false
      t.text :description, null: true

      t.timestamps null: false
    end
  end
end
