class ScheduleUserNotificationsJob < ApplicationJob
  queue_as :default

  def perform
    now = Time.current

    User.where(notification_time: now.strftime("%H:%M")).find_each do |user|
      SendUserNotificationJob.perform_later(user.id)
    end
  end
end
