class CreateTouches < ActiveRecord::Migration
  def change
    create_table :touches do |t|
      t.references :contact
      t.boolean :by_email
      t.boolean :by_phone
      t.boolean :by_visit
      t.datetime :visit_at
      t.datetime :touch_from
      t.datetime :between_start
      t.datetime :between_end
      t.boolean :completed
      t.text :description

      t.timestamps
    end
    add_index :touches, :contact_id
  end
end
