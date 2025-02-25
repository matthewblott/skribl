require 'rails_helper'

module AuthenticationHelpers
  def sign_in_as(user)
    visit sign_in_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'
  end
  
  def post_sign_in_as(user)
    post sign_in_path, params: { email: user.email, password: user.password }
  end

end

