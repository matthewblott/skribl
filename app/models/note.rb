class Note < ApplicationRecord
  before_create { self.id ||= SecureRandom.uuid }
  validates :content, presence: true
  # validates :id, presence: true

  attr_accessor :user_id
  attr_accessor :img

  scope :recent_first, -> { order(created_at: :desc) }

  # after_create_commit -> { 
  #   broadcast_prepend_to :notes_after_create_stream,
  #     target: :notes_element,
  #     partial: "notes/note",
  #     locals: { note: self }
  # }

  # After the note is created there is no image yet so a placeholder
  # needs to be appended to the DOM with the note id. This acts as the
  # identifier for the where to attach the new image when the image_to_file
  # job is run.
  # after_create_commit -> {
  #   broadcast_prepend_to :user_notes_stream,
  #     target: "user_#{self.user_id}_notes",
  #     partial: "notes/note",
  #     locals: { note: self }
  #   broadcast_replace_to :user_note_dispatcher_stream,
  #     target: "user_#{self.user_id}_note_dispatcher",
  #     partial: "notes/note_dispatcher",
  #     locals: { note: self }
  # } 

end
