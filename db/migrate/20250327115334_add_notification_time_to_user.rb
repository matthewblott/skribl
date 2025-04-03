class AddNotificationTimeToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :notification_time, :time, null: false, default: '07:00'
  end
end
