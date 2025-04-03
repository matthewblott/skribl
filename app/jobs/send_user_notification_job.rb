class SendUserNotificationJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find_by(id: user_id)
    return unless user

    # Your notification logic here (email, push notification, etc.)
    UserMailer.daily_notification(user).deliver_now
  end

end
