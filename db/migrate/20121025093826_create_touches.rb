class CreateTouches < ActiveRecord::Migration
  def change
    create_table :touches do |t|
      t.references :contact, null: false
      t.boolean :by_phone
      t.boolean :by_visit
      t.datetime :touch_from, null: false
      t.boolean :completed
      t.text :additional_information

      t.timestamps
    end
    add_index :touches, :contact_id
  end
end
