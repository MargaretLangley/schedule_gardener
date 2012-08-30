class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.datetime :starts_at, null: false
      t.datetime :ends_at
      t.boolean :all_day, default: false
      t.text :description

      t.timestamps
    end
  end
end
