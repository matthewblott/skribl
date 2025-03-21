class Note < UserRecord 
  # validates :title, length: { maximum: 255 }, allow_blank: true
  # validates :content, presence: true
  before_save :strip_whitespace
  before_validation :set_uuid, on: :create
  attr_accessor :img

  # Use a custom connection handler per user
  # self.primary_key = 'id'
  # before_create :set_uuid, unless: -> { id.present? }


  scope :recent_first, -> { order(created_at: :desc) }

  # This model will connect to different databases based on the current user
  def self.set_database_connection(user)
    return unless user # Don't try to connect if no user
    
    begin
      # Only establish new connection if needed
      unless connected_to_user?(user)
        config = UserDatabaseService.get_connection_config(user)
        establish_connection(config)
        connection.reconnect! # Ensure connection is fresh
      end
    rescue => e
      Rails.logger.error "Failed to connect to user database: #{e.message}"
      raise e # Re-raise to handle at controller level
    end
  end

  def self.connected_to_user?(user)
    return false unless user
    
    begin
      current_config = connection_config
      user_config = UserDatabaseService.get_connection_config(user)
      
      current_config['database'] == user_config['database']
    rescue => e
      Rails.logger.error "Error checking database connection: #{e.message}"
      false # If we can't verify, assume we need to reconnect
    end
  end


  private

  def set_uuid
    self.id ||= SecureRandom.uuid
    # self.id = SecureRandom.uuid
    # Rails.logger.debug "Generated UUID: #{self.id}"
  end

  def strip_whitespace
    # self.title = title.strip if title.present?
    self.content = content.strip if content.present?
  end
end
