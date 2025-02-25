require 'fileutils'

class UserDatabaseService
  def self.create_database(user)
    # Ensure storage directory exists
    FileUtils.mkdir_p('storage')
    
    database_name = "storage/user_#{user.id}.sqlite3"
    Rails.logger.info "Creating database at #{database_name}"
    
    # Create SQLite database file if it doesn't exist
    unless File.exist?(database_name)
      Rails.logger.info "Database doesn't exist, creating..."
      SQLite3::Database.new(database_name) do |db|
        db.execute <<-SQL
          CREATE TABLE IF NOT EXISTS notes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title VARCHAR,
            content TEXT,
            created_at DATETIME,
            updated_at DATETIME
          );
        SQL
      end
      Rails.logger.info "Database created successfully"
    else
      Rails.logger.info "Database already exists"
    end
    
    # Verify the database is accessible
    begin
      SQLite3::Database.new(database_name) do |db|
        result = db.get_first_value("SELECT COUNT(*) FROM notes")
        Rails.logger.info "Database verified: found #{result} notes"
      end
    rescue => e
      Rails.logger.error "Failed to verify database: #{e.message}"
      raise e
    end
  end

  def self.get_connection_config(user)
    {
      adapter: 'sqlite3',
      database: "storage/user_#{user.id}.sqlite3"
    }
  end
end
