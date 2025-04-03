require 'rails_helper'
require 'pagy/extras/array'

RSpec.describe 'notes/index', type: :view do
  include Pagy::Backend

  let(:user) { create(:user) }
  let(:notes) do
    Note.set_database_connection(user)
    Note.delete_all # Clean the test database
    50.times.map { |n| create(:note, content: "Note content #{n + 1}") }
    Note.recent_first
  end

  before(:each) do
    Note.set_database_connection(user)
    allow(Current).to receive(:user).and_return(user)
     pagy, paginated_notes = pagy_array(notes)                                                                                                                                                 
     assign(:pagy, pagy)                                                                                                                                                                       
     assign(:notes, paginated_notes)                                                                                                                                                           
  end

  it 'renders the notes header' do
    render
    assert_select 'h1', text: 'My Notes', count: 1
    assert_select 'a[href=?]', new_user_note_path(user), text: 'New Note'
  end

  it 'renders a list of notes' do
    render

    assert_select 'a.note > img[title=?]', 'Note content 50', count: 1
    assert_select 'a.note > img[title=?]', 'Note content 43', count: 1
    assert_select 'a.note > img[title=?]', 'Note content 42', count: 0
  end
  
end
