class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.belongs_to  :user, null: false, index: true
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: true
      t.string :home_phone, null: false
      t.string :mobile, null: true
      t.integer :role, null: false, default: 0
      t.timestamps null: false
    end
  end
end
