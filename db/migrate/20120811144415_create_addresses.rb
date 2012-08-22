class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.references :addressable, :polymorphic => true
      t.string :house_name
      t.string :street_number, null: false
      t.string :street_name, null: false
      t.string :address_line_2
      t.string :town, null: false
      t.string :post_code
      t.timestamps
    end
  end
end
