class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :password_digest, null: false
      t.string :remember_token, null: true, index: true
      t.string :password_reset_token, null: true
      t.datetime :password_reset_sent_at, null: true
      t.boolean :email_verified, default: false
      t.string :verify_email_token, null: true
      t.datetime :verify_email_sent_at, null: true
      t.timestamps null: false
    end

    # add_index :users, :email, unique: true
  end
end
