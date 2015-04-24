class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :password_digest, null: false
      t.string :remember_token
      t.string :password_reset_token
      t.datetime :password_reset_sent_at
      t.boolean :email_verified, default: false
      t.string :verify_email_token
      t.datetime :verify_email_sent_at
      t.timestamps
    end

    # add_index :users, :email, unique: true
    add_index :users, :remember_token
  end
end
