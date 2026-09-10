class AlertBroadcaster
  def self.broadcast(user_id, message, type: :alert)
    Apartment::Tenant.switch(user_id.to_s) do
      Turbo::StreamsChannel.broadcast_append_to(
        AlertsChannel.stream_name_for(user_id),
        target: 'alerts',
        partial: 'shared/alert',
        locals: { message: message, type: type }
      )
    end
  end
end
