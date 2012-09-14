class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.references :contactable, polymorphic: true
      t.string :first_name, null: false
      t.string :last_name
      t.string :email
      t.string :home_phone, null: false
      t.string :mobile
      t.string :role, null: false
      t.timestamps
    end
  end
end
