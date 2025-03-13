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
    fill_in 'note_content', with: 'This is my first note'
    click_button 'Create Note'
    expect(page).to have_current_path(user_notes_path(user))
    expect(page).to have_content('This is my first note')
  end

  it 'creates a note and updates the note' do
    sign_in_as(user)
    click_link 'New Note'
    expect(page).to have_current_path(new_user_note_path(user))
    fill_in 'note_content', with: 'This is my first note to update'
    click_button 'Create Note'
    expect(page).to have_current_path(user_notes_path(user))
    expect(page).to have_content('This is my first note to update')
    
    click_button 'Sign out'

    sign_in_as(user)

    all("a", text: "Edit").last.click

    expect(page).to have_selector('h1', text: 'Edit Note')

    fill_in 'note_content', with: 'This content has been updated'

    click_button 'Update Note'

    # Verify we're redirected to the notes index page
    expect(page).to have_current_path(user_notes_path(user))
    expect(page).to have_content('This content has been updated')

  end

  it 'creates a note and deletes the note' do
    sign_in_as(user)
    click_link 'New Note'
    expect(page).to have_current_path(new_user_note_path(user))
    fill_in 'note_content', with: 'This is my first note to delete'
    click_button 'Create Note'
    expect(page).to have_current_path(user_notes_path(user))
    expect(page).to have_content('This is my first note to delete')
    
    click_button 'Sign out'

    sign_in_as(user)

    all("a", text: "Edit").first.click

    expect(page).to have_selector("textarea", text: "This is my first note to delete")

    accept_prompt do
      click_link 'Delete Note'
    end

    expect(page).to have_selector('h1', text: 'My Notes')
    expect(page).to_not have_content('This is my first note to delete')

  end

end
