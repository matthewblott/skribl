require 'rails_helper'

RSpec.describe Note, type: :model do
  let(:user) { create(:user) }

  before(:each) do
    Note.set_database_connection(user)
    Note.delete_all
  end

  describe 'validations' do
    subject { build(:note) }

    it { should_not validate_presence_of(:title) }
    it { should validate_presence_of(:content) }
    it { should validate_length_of(:title).is_at_most(255) }

    describe 'title validations' do
      it 'allows empty title' do
        note = build(:note, title: '')
        expect(note).to be_valid
      end

      it 'limits title length' do
        note = build(:note, title: 'a' * 256)
        expect(note).not_to be_valid
        expect(note.errors[:title]).to include('is too long (maximum is 255 characters)')
      end
    end

    describe 'content validations' do
      it 'requires content' do
        note = build(:note, content: '')
        expect(note).not_to be_valid
        expect(note.errors[:content]).to include("can't be blank")
      end
    end
  end

  describe 'whitespace handling' do
    it 'strips whitespace from title' do
      note = create(:note, title: '  My Note  ', content: 'Content')
      expect(note.title).to eq('My Note')
    end

    it 'strips whitespace from content' do
      note = create(:note, title: 'Title', content: '  My content  ')
      expect(note.content).to eq('My content')
    end

    it 'handles nil values' do
      note = Note.new
      expect { note.save }.not_to raise_error
    end
  end

  describe 'database isolation' do
    let(:another_user) { create(:user) }

    before(:each) do
      # Clean both users' databases
      [user, another_user].each do |u|
        Note.set_database_connection(u)
        Note.delete_all
      end
      # Set back to the main test user's database
      Note.set_database_connection(user)
    end

    it 'stores notes in user-specific database' do
      # Create a note for the first user
      create(:note, title: 'First User Note')
      expect(Note.count).to eq(1)
      expect(Note.first.title).to eq('First User Note')

      # Switch to second user's database
      Note.set_database_connection(another_user)
      expect(Note.count).to eq(0) # Verify empty database
      create(:note, title: 'Second User Note')
      expect(Note.count).to eq(1)
      expect(Note.first.title).to eq('Second User Note')

      # Switch back to first user's database
      Note.set_database_connection(user)
      expect(Note.count).to eq(1)
      expect(Note.first.title).to eq('First User Note')
    end
  end

  describe 'basic CRUD operations' do
    it 'can create a note' do
      note = create(:note)
      expect(note).to be_persisted
    end

    it 'can read a note' do
      created_note = create(:note)
      found_note = Note.find(created_note.id)
      expect(found_note).to eq(created_note)
    end

    it 'can update a note' do
      note = create(:note)
      new_title = 'Updated Title'
      note.update(title: new_title)
      expect(note.reload.title).to eq(new_title)
    end

    it 'can delete a note' do
      note = create(:note)
      expect { note.destroy }.to change(Note, :count).by(-1)
    end
  end
end
