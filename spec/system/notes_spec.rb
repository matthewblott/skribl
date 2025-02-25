require 'rails_helper'

RSpec.describe "Notes", type: :system do
  let(:user) { create(:user) }

  before do
    driven_by(:cuprite)
  end

  it 'renders homepage' do
    sign_in_as(user)
    expect(page).to have_current_path(user_notes_path(user))
    within 'main' do
      expect(page).to have_selector('h1', text: 'My Notes')
    end
  end

  describe "creating a note" do
    it "creates a new note successfully after signing in" do
      sign_in_as(user)
      
      # Create a new note
      click_link "New Note"
      fill_in "Title", with: "Test Note"
      fill_in "Content", with: "This is a test note content"
      click_button "Create Note"

      # Verify the note was created
      expect(page).to have_text("Note was successfully created")
      expect(page).to have_selector('h1', text: 'Test Note')
      expect(page).to have_text("This is a test note content")
    end
  end
end
