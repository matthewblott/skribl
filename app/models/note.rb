class Note < ApplicationRecord
  # This model will connect to different databases based on the current user
  def self.set_database_connection(user)
    establish_connection(UserDatabaseService.get_connection_config(user))
  end
end
