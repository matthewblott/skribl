require 'rails_helper'

describe 'Sign in', type: :feature do
  it 'renders sign-in page' do
    visit sign_in_path 

    within 'h1' do
      expect(page).to have_text 'Sign in'
    end

  end

  it 'allows the user to sign in' do
    create(:user, email: 'foo@example.com', password: 'password12345')

    visit sign_in_path 

    fill_in 'email', with: 'foo@example.com'
    fill_in 'password', with: 'password12345'
    click_button 'Sign in'

    within 'body' do
      expect(page).to have_text 'Signed in as foo@example.com'
    end

  end

  it 'prevents a user from signing in with an invalid password' do
    create(:user, email: 'foo@example.com', password: 'password12345')

    visit sign_in_path 

    fill_in 'email', with: 'foo@example.com'
    fill_in 'password', with: 'password'
    click_button 'Sign in'

    within 'body' do
      expect(page).to have_text 'That email or password is incorrect'
    end

  end

  it 'prevents a user from signing in with an invalid email' do
    create(:user, email: 'foo@example.com', password: 'password12345')

    visit sign_in_path 

    fill_in 'email', with: 'bar@example.com'
    fill_in 'password', with: 'password12345'
    click_button 'Sign in'

    within 'body' do
      expect(page).to have_text 'That email or password is incorrect'
    end

  end

end

