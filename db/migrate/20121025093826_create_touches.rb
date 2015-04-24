class CreateTouches < ActiveRecord::Migration
  def change
    create_table :touches do |t|
      t.belongs_to :contact, null: false, index: true
      t.boolean :by_phone, null: true
      t.boolean :by_visit, null: true
      t.datetime :touch_from, null: false
      t.boolean :completed, null: true
      t.text :additional_information

      t.timestamps null: false
    end
  end
end
