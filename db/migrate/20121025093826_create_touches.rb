class CreateTouches < ActiveRecord::Migration
  def change
    create_table :touches do |t|
      t.references :contact
      t.boolean :by_phone
      t.boolean :by_visit
      t.datetime :touch_from, null: false
      t.datetime :between_start
      t.datetime :between_end
      t.boolean :completed
      t.text :additional_information

      t.timestamps
    end
    add_index :touches, :contact_id
  end
end
