class AddTotpSecretToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :totp_secret, :string
  end
end
