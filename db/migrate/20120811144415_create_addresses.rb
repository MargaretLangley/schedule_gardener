class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.belongs_to :addressable, polymorphic: true, index: true
      t.string :house_name, null: true
      t.string :street_number, null: false
      t.string :street_name, null: false
      t.string :address_line_2, null: true
      t.string :town, null: false
      t.string :post_code, null: true
      t.timestamps null: false
    end
  end
end
