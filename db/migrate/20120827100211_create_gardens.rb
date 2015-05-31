class CreateGardens < ActiveRecord::Migration
  def change
    create_table :gardens do |t|
      t.belongs_to :person, null: false, index: true

      t.timestamps null: false
    end
  end
end
