require 'rails_helper'

RSpec.describe NotesController, type: :routing do
  describe "routing" do
    let(:user_id) { "1" }
    let(:note_id) { "2" }

    it "routes to #index" do
      expect(get: user_notes_path(user_id)).to route_to(
        controller: "notes",
        action: "index",
        user_id: user_id
      )
    end

    it "routes to #new" do
      expect(get: new_user_note_path(user_id)).to route_to(
        controller: "notes",
        action: "new",
        user_id: user_id
      )
    end

    it "routes to #show" do
      expect(get: user_note_path(user_id, note_id)).to route_to(
        controller: "notes",
        action: "show",
        user_id: user_id,
        id: note_id
      )
    end

    it "routes to #edit" do
      expect(get: edit_user_note_path(user_id, note_id)).to route_to(
        controller: "notes",
        action: "edit",
        user_id: user_id,
        id: note_id
      )
    end

    it "routes to #create" do
      expect(post: user_notes_path(user_id)).to route_to(
        controller: "notes",
        action: "create",
        user_id: user_id
      )
    end

    it "routes to #update via PUT" do
      expect(put: user_note_path(user_id, note_id)).to route_to(
        controller: "notes",
        action: "update",
        user_id: user_id,
        id: note_id
      )
    end

    it "routes to #update via PATCH" do
      expect(patch: user_note_path(user_id, note_id)).to route_to(
        controller: "notes",
        action: "update",
        user_id: user_id,
        id: note_id
      )
    end

    it "routes to #destroy" do
      expect(delete: user_note_path(user_id, note_id)).to route_to(
        controller: "notes",
        action: "destroy",
        user_id: user_id,
        id: note_id
      )
    end

  end
end