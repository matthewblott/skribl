require 'rails_helper'

RSpec.describe "Notes", type: :system do
  let(:user) { create(:user) }

  before do
    driven_by(:cuprite)
    # Ensure user database is ready
    Note.set_database_connection(user)
  end

  it 'renders homepage' do
    sign_in_as(user)
    expect(page).to have_current_path(user_notes_path(user))
    expect(page).to have_selector('h1', text: 'My Notes')
  end

end

