class ScheduleUserNotificationsJob < ApplicationJob
  queue_as :default

  def perform
    # now = Time.current

    # start_time = Time.zone.parse("2000-01-01 #{(now - 1.minute).strftime("%H:%M")}")
    # end_time   = Time.zone.parse("2000-01-01 #{now.strftime("%H:%M")}")
    # User.where(notification_time: start_time..end_time).find_each do |user|
    #   SendUserNotificationJob.perform_later(user.id)
    # end

    # normalized_now = Time.zone.parse("2000-01-01 #{now.strftime("%H:%M")}")
    # window_start = Time.zone.parse("2000-01-01 #{(now - 1.minute).strftime("%H:%M")}")
    # users = User.where(notification_time: window_start..normalized_now)

    # now = Time.current.strftime("%H:%M:%S")
    # users = User.where("time(notification_time) = ?", now)

    now = Time.current
    start_time = (now - 1.minute).strftime("%H:%M:%S")
    end_time   = now.strftime("%H:%M:%S")

    users = User.where("time(notification_time) BETWEEN ? AND ?", start_time, end_time)

    users.find_each do |user|
      SendUserNotificationJob.perform_later(user.id)
    end

  end
end
