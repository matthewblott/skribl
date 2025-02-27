require 'rails_helper'

describe "Notes", type: :system do
  before do
    driven_by(:cuprite)
    # Ensure user database is ready
    Note.set_database_connection(user)
  end

  let(:user) { create(:user) }

  it 'renders homepage' do
    sign_in_as(user)
    expect(page).to have_current_path(user_notes_path(user))
    expect(page).to have_selector('h1', text: 'My Notes')
  end

  it 'creates a new note' do
    sign_in_as(user)
    click_link 'New Note'
    expect(page).to have_current_path(new_user_note_path(user))
    fill_in 'Title', with: 'My First Note'
    fill_in 'Content', with: 'This is my first note'
    click_button 'Create Note'
    expect(page).to have_current_path(user_note_path(user, Note.last))
    expect(page).to have_selector('h1', text: 'My First Note')
  end

  it 'creates a note and updates the note' do
    sign_in_as(user)
    click_link 'New Note'
    expect(page).to have_current_path(new_user_note_path(user))
    fill_in 'Title', with: 'My First Note To Update'
    fill_in 'Content', with: 'This is my first note to update'
    click_button 'Create Note'
    expect(page).to have_current_path(user_note_path(user, Note.last))
    expect(page).to have_selector('h1', text: 'My First Note To Update')
    
    click_button 'Sign out'

    sign_in_as(user)

    # within(:xpath, "//div[h2[text()='My First Note To Update']]") do
    #   click_link "Edit"
    # end

    all("a", text: "Edit").last.click

    expect(page).to have_selector('h1', text: 'Edit Note')

    fill_in 'Title', with: 'This title has been updated'
    fill_in 'Content', with: 'This content has been updated'

    click_button 'Update Note'

    expect(page).to have_selector('h1', text: 'This title has been updated')
    expect(page).to have_selector('p', text: 'This content has been updated')

  end

end

