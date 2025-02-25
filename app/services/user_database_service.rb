class UserDatabaseService
  def self.create_database(user)
    database_name = "storage/user_#{user.id}.sqlite3"
    
    # Create SQLite database file
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
  end

  def self.get_connection_config(user)
    {
      adapter: 'sqlite3',
      database: "storage/user_#{user.id}.sqlite3"
    }
  end
end
