class CreateGardens < ActiveRecord::Migration
  def change
    create_table :gardens do |t|
      t.references :contact

      t.timestamps
    end
  end
end
