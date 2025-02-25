require 'fileutils'

class UserDatabaseService
  def self.create_database(user)
    # FileUtils.mkdir_p(Rails.root.join("db/user_databases"))

    database_path = "storage/user_#{user.id}.sqlite3"

    ActiveRecord::Base.establish_connection(
      adapter: "sqlite3",
      database: database_path
    )

    ActiveRecord::Base.connection.execute(<<-SQL)
      CREATE TABLE IF NOT EXISTS notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        content TEXT,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
      );
    SQL
  end
end

