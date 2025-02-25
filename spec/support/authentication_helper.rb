module AuthenticationHelper
  def sign_in_as(user)
    # Create session and set cookie directly
    session = Session.create!(user: user)
    page.driver.set_cookie(:session_token, session.id.to_s)

    # Set Current.user and Current.session
    Current.user = user
    Current.session = session

    # Create and set up database connection
    UserDatabaseService.create_database(user)
    Note.set_database_connection(user)

    # Visit the notes page directly
    visit user_notes_path(user)
  end
  
  def post_sign_in_as(user)
    post sign_in_path, params: { email: user.email, password: user.password }
  end
end
