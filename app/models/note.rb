class Note < UserRecord 
  before_save :strip_whitespace
  attr_accessor :img

  scope :recent_first, -> { order(created_at: :desc) }

  def initialize(attributes = nil)
    super
    self.id = SecureRandom.uuid if new_record?
  end

  def self.set_database_connection(user)
    return unless user
    
    begin
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

  def self.connected_to_user?(user)
    return false unless user
    
    begin
      user_config = UserDatabaseService.get_connection_config(user)
      database = user_config['database'] 
      database_user_id = database[/#{Rails.env}_user_(\d+)/, 1]
      database_user_id == user.id.to_s
    rescue
      false
    end
  end

  after_create_commit -> {
    # Possibly the notes stream should be named dynamically
    broadcast_prepend_to :notes_after_create_stream,
    target: "notes_user_#{CurrentNoteContext.user_id}_element",
      partial: "notes/note",
      locals: { note: self }
  } 

  private

  def strip_whitespace
    self.content = content.strip if content.present?
  end
end
