class UserDatabaseService
  def self.create_database(user)
    database_name = "storage/#{Rails.env}_user_#{user.id}.sqlite3"
    
    # Create SQLite database file
    SQLite3::Database.new(database_name) do |db|
      db.execute <<-SQL
        CREATE TABLE IF NOT EXISTS notes (
          id uuid NOT NULL PRIMARY KEY,
          title VARCHAR,
          content TEXT,
          image_saved BOOLEAN,
          created_at DATETIME,
          updated_at DATETIME
        );
      SQL
    end
  end

  def self.delete_database(user)

    database_name = "storage/#{Rails.env}_user_#{user.id}.sqlite3"
    # debugger
    File.delete(database_name) if File.exist?(database_name)

    # Delete the WAL (Write-Ahead Log) file
    wal_file = "#{database_name}-wal"
    File.delete(wal_file) if File.exist?(wal_file)
    
    # Delete the SHM (Shared Memory) file
    shm_file = "#{database_name}-shm"
    File.delete(shm_file) if File.exist?(shm_file)

  end

  def self.get_connection_config(user)
    {
      adapter: 'sqlite3',
      database: "storage/#{Rails.env}_user_#{user.id}.sqlite3"
    }
  end
end
