class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email,           null: false, index: { unique: true }
      t.string :password_digest, null: false
      t.boolean :verified, null: false, default: false
      t.time    :notification_time, null: false, default: "07:00"
      t.string  :totp_secret
      t.timestamps
    end
  end
end
