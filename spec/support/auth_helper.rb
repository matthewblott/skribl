module AuthHelper
  def sign_in(user)
    # Create a session for the user
    session = Session.create!(user: user)
    
    # In test environment, we need to set both the cookie and the header
    cookies[:session_token] = session.id.to_s
    
    # Set Current.user for the request
    Current.user = user
    Current.session = session

    # Set database connection like production does
    Note.set_database_connection(user)
  end

  def sign_out
    cookies.delete(:session_token)
    Current.user = nil
    Current.session = nil
  end
end

RSpec.configure do |config|
  config.include AuthHelper, type: :request
  config.include AuthHelper, type: :system
end
