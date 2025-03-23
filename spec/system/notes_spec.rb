require 'rails_helper'
require 'uri'

describe 'Notes', type: :system do
  before do
    driven_by(:cuprite)
    # Ensure user database is ready
    Note.set_database_connection(user)
    Note.delete_all # Clean the test database
    # 50.times.map { |n| create(:note, content: "Note content #{n + 1}") }

    50.times.map do |n| 
      note = create(:note, content: "Note content #{n + 1}") 
      source_file = File.open(Rails.root.join('spec', 'images', 'test_image.png'))
      new_file = Rails.root.join('public', 'uploads', "user_#{user.id}", "#{note.id}.png")
      FileUtils.cp(source_file, new_file)
    end 

  end

  let(:user) { create(:user) }

  before(:each) do
    sign_in_as(user)
  end

  it 'renders notes index page' do
    expect(page).to have_current_path(user_notes_path(user))
    expect(page).to have_selector('h1', text: 'My Notes')

    expect(page).to have_css get_image_url(get_note(50).id)
    expect(page).to have_css get_image_url(get_note(43).id)
    expect(page).to_not have_css get_image_url(get_note(42).id)

    note_images = all('a.note > img')

    expect(note_images.first[:title]).to eq("Note content #{50}")
    expect(note_images.last[:title]).to eq("Note content #{43}")

    note_images.each do |note_image|
      expect(note_image[:title]).to_not eq("Note content #{42}")
    end 

  end

  it 'renders next notes and previous notes pages' do
    click_link 'Next'

    expect(page).to_not have_css get_image_url(get_note(43).id)
    expect(page).to have_css get_image_url(get_note(42).id)
    expect(page).to have_css get_image_url(get_note(35).id)
    expect(page).to_not have_css get_image_url(get_note(34).id)

    note_images = all('a.note > img')

    expect(note_images.first[:title]).to eq("Note content #{42}")
    expect(note_images.last[:title]).to eq("Note content #{35}")

    note_images.each do |note_image|
      expect(note_image[:title]).to_not eq("Note content #{43}")
      expect(note_image[:title]).to_not eq("Note content #{34}")
    end 

    click_link 'Previous'

    expect(page).to have_css get_image_url(get_note(50).id)
    expect(page).to have_css get_image_url(get_note(43).id)
    expect(page).to_not have_css get_image_url(get_note(42).id)

    note_images = all('a.note > img')

    expect(note_images.first[:title]).to eq("Note content #{50}")
    expect(note_images.last[:title]).to eq("Note content #{43}")

    note_images.each do |note_image|
      expect(note_image[:title]).to_not eq("Note content #{42}")
    end 
  end

  it 'renders last and first notes pages' do
    click_link 'Last'

    expect(page).to have_css get_image_url(get_note(2).id)
    expect(page).to have_css get_image_url(get_note(1).id)
    expect(page).to_not have_css get_image_url(get_note(3).id)

    note_images = all('a.note > img')

    expect(note_images.first[:title]).to eq("Note content #{2}")
    expect(note_images.last[:title]).to eq("Note content #{1}")

    note_images.each do |note_image|
      expect(note_image[:title]).to_not eq("Note content #{3}")
    end 

    click_link 'First'

    expect(page).to have_css get_image_url(get_note(50).id)
    expect(page).to have_css get_image_url(get_note(43).id)
    expect(page).to_not have_css get_image_url(get_note(42).id)

    note_images = all('a.note > img')

    expect(note_images.first[:title]).to eq("Note content #{50}")
    expect(note_images.last[:title]).to eq("Note content #{43}")

    note_images.each do |note_image|
      expect(note_image[:title]).to_not eq("Note content #{42}")
    end 

  end

  it 'creates a new note' do
    click_link 'New Note'

    expect(page).to have_current_path(new_user_note_path(user))

    fill_in 'note[content]', with: 'This is my first note'
    
    draw_on_canvas(page)

    click_button 'Create Note'

    expect(page).to have_current_path(user_notes_path(user))
    
    note_images = all('a.note > img')

    expect(note_images.first[:title]).to eq("This is my first note")
    
    image_src = note_images.first[:src]
    filename = File.join(Rails.root.realpath, 'public', strip_to_path(image_src))
    
    expect(File.exist?(filename)).to eq(true) 

  end

  it 'creates a new note on mobile' do
    click_link 'New Note'

    expect(page).to have_current_path(new_user_note_path(user))

    fill_in 'note[content]', with: 'This is my first note'
    
    draw_on_canvas_using_touch(page)

    click_button 'Create Note'

    expect(page).to have_current_path(user_notes_path(user))
    
    note_images = all('a.note > img')

    expect(note_images.first[:title]).to eq("This is my first note")
    
    image_src = note_images.first[:src]
    filename = File.join(Rails.root.realpath, 'public', strip_to_path(image_src))
    
    expect(File.exist?(filename)).to eq(true) 
  end

  it 'creates a note and deletes the note' do
    click_link 'New Note'

    expect(page).to have_current_path(new_user_note_path(user))

    fill_in 'note[content]', with: 'This is my first note to delete'
    
    draw_on_canvas(page)

    click_button 'Create Note'

    expect(page).to have_current_path(user_notes_path(user))
    
    note_images = all('a.note > img')

    expect(note_images.first[:title]).to eq("This is my first note to delete")
    
    image_src = note_images.first[:src]
    filename = File.join(Rails.root.realpath, 'public', strip_to_path(image_src))
    
    expect(File.exist?(filename)).to eq(true) 

    click_button 'Sign out'

    sign_in_as(user)

    all('a.note').first.click

    expect(page).to have_field('note[content]', with: 'This is my first note to delete')

    accept_prompt do
      click_link 'Delete Note'
    end

    expect(page).to have_selector('h1', text: 'My Notes')

    note_images = all('a.note > img')

    expect(note_images.first[:title]).to_not eq("This is my first note")

  end

  private

  def get_note(note_number) = Note.order(:created_at).offset(note_number - 1).first
  def get_image_url(note_id) = "img[src='/uploads/user_#{user.id}/#{note_id}.png']"
  def reverse_position(n) = 50 - n
  def strip_to_path(url)
    uri = URI.parse(url)
    uri.path + (uri.query ? "?#{uri.query}" : "") + (uri.fragment ? "##{uri.fragment}" : "")
  end
end
