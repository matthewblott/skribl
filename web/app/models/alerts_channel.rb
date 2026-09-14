class AlertsChannel
  def self.stream_name_for(user_id)
    "alerts_#{user_id}"
  end
end
