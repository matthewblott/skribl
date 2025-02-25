require 'rails_helper'

RSpec.describe "notes/index", type: :view do
  let(:user) { create(:user) }
  let(:notes) do
    [
      create(:note, title: "First Note", content: "First note content", user: user),
      create(:note, title: "Second Note", content: "Second note content", user: user)
    ]
  end

  before(:each) do
    allow(Current).to receive(:user).and_return(user)
    assign(:notes, notes)
  end

  it "renders the notes header" do
    render
    assert_select "h1", text: "My Notes", count: 1
    assert_select "a[href=?]", new_user_note_path(user), text: "New Note"
  end

  it "renders a list of notes" do
    render
    assert_select 'h2', text: "First Note"
    assert_select 'h2', text: "Second Note"
    assert_select 'p', text: "First note content"
    assert_select 'p', text: "Second note content"
  end
end