module AuthHelper
  def sign_in(user)
    session = Session.create!(user: user)
    
    # In test environment, we set the cookie directly (not signed)
    cookies[:session_token] = session.id
    
    Current.user = user
    Current.session = session

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
