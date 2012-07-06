class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest
      t.string :remember_token
      t.string :address_line_1
      t.string :address_line_2
      t.string :town
      t.string :post_code
      t.string :phone_number
      t.text :garden_requirements

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :remember_token
  end
end
