namespace :db do
  desc "Run migrations for main database"
  task migrate_main: :environment do
    # Run migrations for main database
    ActiveRecord::Base.establish_connection(:primary)
    ActiveRecord::MigrationContext.new(
      Rails.root.join("db/migrate"),
      ActiveRecord::SchemaMigration
    ).migrate
  end

  desc "Run migrations for user-specific database"
  task migrate_user: :environment do
    unless ENV["USER_ID"]
      puts "Please provide USER_ID"
      exit 1
    end

    # Configure database for specific user
    database = Rails.configuration.database_configuration[Rails.env]["user_specific"]["database"]
    database = database % { user_id: ENV["USER_ID"] }
    
    # Create database directory if it doesn't exist
    FileUtils.mkdir_p(File.dirname(database))

    # Run migrations
    config = Rails.configuration.database_configuration[Rails.env]["user_specific"].merge(
      "database" => database
    )
    
    # Create schema_migrations table if it doesn't exist
    ActiveRecord::Base.establish_connection(config)
    unless ActiveRecord::Base.connection.table_exists?('schema_migrations')
      ActiveRecord::Base.connection.create_table('schema_migrations', id: false) do |t|
        t.string :version, primary_key: true
      end
    end
    
    # Run migrations
    ActiveRecord::MigrationContext.new(
      Rails.root.join("db/user_migrate"),
      ActiveRecord::Base.connection
    ).migrate
  end

  # Override default migrate task
  task migrate: :environment do
    if ENV["USER_ID"]
      Rake::Task["db:migrate_user"].invoke
    else
      Rake::Task["db:migrate_main"].invoke
    end
  end
end
