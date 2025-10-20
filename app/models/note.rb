class Note < UserRecord 
  before_save :strip_whitespace
  # before_validation :set_uuid, on: :create
  attr_accessor :img

  scope :recent_first, -> { order(created_at: :desc) }

  def initialize(attributes = nil)
    super
    self.id = SecureRandom.uuid if new_record?
  end

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
      CurrentNoteContext.user_id = user.id
    rescue => e
      Rails.logger.error "Failed to connect to user database: #{e.message}"
      raise e # Re-raise to handle at controller level
    end
  end

  after_create_commit -> {
    broadcast_prepend_to "notes",
    target: "notes_user_#{CurrentNoteContext.user_id}",
      partial: "notes/note",
      locals: { note: self }
  } 

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

  # def set_uuid
  #   self.id ||= SecureRandom.uuid
  # end

  def strip_whitespace
    self.content = content.strip if content.present?
  end
end
