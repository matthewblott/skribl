module AuthHelper
  def sign_in(user)
    # Create a session for the user
    session = Session.create!(user: user)
    
    # In test environment, we set the cookie directly (not signed)
    cookies[:session_token] = session.id
    
    # Set Current.user for the request
    Current.user = user
    Current.session = session

    # Set database connection like production does
    Note.set_database_connection(user)
  end

  def sign_in_as(user)
    visit sign_in_path
    # Wait for form to be ready
    expect(page).to have_selector('form')
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'
  end
  
  def post_sign_in_as(user)
    post sign_in_path, params: { email: user.email, password: user.password }
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
