require 'rails_helper'

RSpec.describe "Notes", type: :request do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:valid_attributes) { { content: "This is a test note" } }
  let(:invalid_attributes) { { content: "" } }

  before do
    sign_in(user)
  end

  describe "GET /notes" do
    it "returns a successful response" do
      get user_notes_path(user)
      expect(response).to be_successful
    end

    it "shows only the current user's notes" do
      # Create note for current user
      note1 = Note.create!(valid_attributes)

      # Create note for another user
      sign_in(another_user)
      note2 = Note.create!(content: "This shouldn't be visible")

      # Get notes as current user
      sign_in(user)
      get user_notes_path(user)
      expect(response.body).to include(note1.content)
      expect(response.body).not_to include(note2.content)
    end
  end

  describe "GET /notes/:id" do
    it "returns a successful response" do
      note = Note.create!(valid_attributes)
      get user_note_path(user, note)
      expect(response).to be_successful
    end

    it "returns not found for another user's note" do
      # Sign in as another user and create their note
      sign_in(another_user)
      note = Note.create!(valid_attributes)
      
      # Sign back in as original user and try to access the note
      sign_in(user)
      get user_note_path(user, note)
      expect(response).to be_not_found
    end
  end

  describe "post /notes" do
    context "with valid parameters" do
      it "creates a new note" do
        expect {
          post user_notes_path(user), params: { note: valid_attributes }
        }.to change(Note, :count).by(1)
      end

      it "redirects to the created note" do
        post user_notes_path(user), params: { note: valid_attributes }
        expect(response).to redirect_to(user_notes_path(user))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Note" do
        expect {
          post user_notes_path(user), params: { note: invalid_attributes }
        }.to change(Note, :count).by(0)
      end

      it "renders a response with 422 status" do
        post user_notes_path(user), params: { note: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /notes/:id" do
    context "with valid parameters" do
      let(:new_attributes) { { content: "Updated content" } }

      it "updates the requested note" do
        note = Note.create!(valid_attributes)
        patch user_note_path(user, note), params: { note: new_attributes }
        note.reload
        expect(note.content).to eq("Updated content")
      end

      it "redirects to the notes index" do
        note = Note.create!(valid_attributes)
        patch user_note_path(user, note), params: { note: new_attributes }
        expect(response).to redirect_to(user_notes_path(user))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status" do
        note = Note.create!(valid_attributes)
        patch user_note_path(user, note), params: { note: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    it "cannot update another user's note" do
      # Create note for another user
      sign_in(another_user)
      note = Note.create!(valid_attributes)

      # Try to update as current user
      sign_in(user)
      patch user_note_path(user, note), params: { note: { content: "Hacked!" } }
      expect(response).to be_not_found
    end
  end

  describe "DELETE /notes/:id" do
    it "destroys the requested note" do
      note = Note.create!(valid_attributes)
      expect {
        delete user_note_path(user, note)
      }.to change(Note, :count).by(-1)
    end

    it "redirects to the notes list" do
      note = Note.create!(valid_attributes)
      delete user_note_path(user, note)
      expect(response).to redirect_to(user_notes_path(user))
    end

    it "cannot delete another user's note" do
      # Create note for another user
      sign_in(another_user)
      note = Note.create!(valid_attributes)

      # Try to delete as current user
      sign_in(user)

      delete user_note_path(user, note)
      expect(response).to be_not_found
    end
  end

  describe "database isolation" do
    it "maintains separate note counts for different users" do
      # Create notes for current user
      Note.create!(valid_attributes)
      Note.create!(valid_attributes.merge(content: "Second Note Content"))
      expect(Note.count).to eq(2)

      # Switch to another user
      sign_in(another_user)
      Note.set_database_connection(another_user)
      expect(Note.count).to eq(0)
      Note.create!(valid_attributes)
      expect(Note.count).to eq(1)

      # Switch back to first user
      sign_in(user)
      Note.set_database_connection(user)
      expect(Note.count).to eq(2)
    end
  end
end
