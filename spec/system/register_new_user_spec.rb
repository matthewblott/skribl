require 'rails_helper'

describe 'User Registration', type: :feature do
  it 'renders sign-up page' do
    visit sign_up_path 

    within 'h1' do
      expect(page).to have_text 'Sign up'
    end
  end


  it 'registers a new user' do
    visit sign_up_path 

    fill_in 'email', with: 'new_user@example.com'
    fill_in 'password', with: 'password12345'
    fill_in 'password_confirmation', with: 'password12345'
    click_button 'Sign up'

    within 'body' do
      expect(page).to have_text 'Welcome! You have signed up successfully'
    end
  end

end
