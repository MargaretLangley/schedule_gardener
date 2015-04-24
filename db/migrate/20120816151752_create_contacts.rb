class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.belongs_to  :user, null: false, index: true
      t.string :first_name, null: false
      t.string :last_name
      t.string :email
      t.string :home_phone, null: false
      t.string :mobile
      t.integer :role, null: false, default: 0
      t.timestamps
    end
  end
end
