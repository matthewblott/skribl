require 'rails_helper'

describe 'Notes', type: :system do
  before do
    driven_by(:cuprite)
    # Ensure user database is ready
    Note.set_database_connection(user)
    Note.delete_all # Clean the test database
    50.times.map { |n| create(:note, content: "Note content #{n + 1}") }
  end

  let(:user) { create(:user) }

  before(:each) do
    sign_in_as(user)
  end

  it 'renders notes index page' do
    expect(page).to have_current_path(user_notes_path(user))
    expect(page).to have_selector('h1', text: 'My Notes')
    expect(page).to have_selector('p', text: 'Note content 50')
    expect(page).to have_selector('p', text: 'Note content 43')
    expect(page).to_not have_selector('p', text: 'Note content 42')
  end

  it 'renders next notes and previous notes pages' do
    click_link 'Next'
    expect(page).to_not have_selector('p', text: 'Note content 43')
    expect(page).to have_selector('p', text: 'Note content 42')
    expect(page).to have_selector('p', text: 'Note content 35')
    expect(page).to_not have_selector('p', text: 'Note content 34')

    click_link 'Previous'

    expect(page).to have_selector('p', text: 'Note content 50')
    expect(page).to have_selector('p', text: 'Note content 43')
    expect(page).to_not have_selector('p', text: 'Note content 42')
  end

  it 'renders last and first notes pages' do
    click_link 'Last'
    expect(page).to have_selector('p', text: 'Note content 2')
    expect(page).to have_selector('p', text: 'Note content 1')
    expect(page).to_not have_selector('p', text: 'Note content 3')
    click_link 'First'
    expect(page).to have_selector('p', text: 'Note content 50')
    expect(page).to have_selector('p', text: 'Note content 43')
    expect(page).to_not have_selector('p', text: 'Note content 42')
  end

  it 'creates a new note' do
    click_link 'New Note'
    expect(page).to have_current_path(new_user_note_path(user))
    fill_in 'note[content]', with: 'This is my first note'
    
    draw_on_canvas(page)

    click_button 'Create Note'
    expect(page).to have_current_path(user_notes_path(user))
    expect(page).to have_content('This is my first note')
  end


  it 'creates a new note on mobile' do
    click_link 'New Note'
    expect(page).to have_current_path(new_user_note_path(user))
    fill_in 'note[content]', with: 'This is my first note'
    
    draw_on_canvas_using_touch(page)

    click_button 'Create Note'
    expect(page).to have_current_path(user_notes_path(user))
    expect(page).to have_content('This is my first note')
  end

  it 'creates a note and updates the note' do
    click_link 'New Note'
    expect(page).to have_current_path(new_user_note_path(user))
    fill_in 'note_content', with: 'This is my first note to update'
    draw_on_canvas(page)
    click_button 'Create Note'
    expect(page).to have_current_path(user_notes_path(user))
    expect(page).to have_content('This is my first note to update')
    
    click_button 'Sign out'

    sign_in_as(user)

    all('a', text: 'Edit').last.click

    expect(page).to have_selector('h1', text: 'Edit Note')

    fill_in 'note_content', with: 'This content has been updated'
    draw_on_canvas(page)

    click_button 'Update Note'

    # Verify we're redirected to the notes index page
    expect(page).to have_current_path(user_notes_path(user))
    expect(page).to have_content('This content has been updated')

  end

  it 'creates a note and deletes the note' do
    click_link 'New Note'
    expect(page).to have_current_path(new_user_note_path(user))
    fill_in 'note_content', with: 'This is my first note to delete'
    draw_on_canvas(page)
    click_button 'Create Note'
    expect(page).to have_current_path(user_notes_path(user))
    expect(page).to have_content('This is my first note to delete')
    
    click_button 'Sign out'

    sign_in_as(user)

    all('a', text: 'Edit').first.click

    expect(page).to have_field('note[content]', with: 'This is my first note to delete')

    accept_prompt do
      click_link 'Delete Note'
    end

    expect(page).to have_selector('h1', text: 'My Notes')
    expect(page).to_not have_content('This is my first note to delete')

  end

end
