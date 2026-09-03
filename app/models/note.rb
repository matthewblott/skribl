class Note < ApplicationRecord
  before_create { self.id ||= SecureRandom.uuid }
  validates :content, presence: true
  # validates :id, presence: true

  attr_accessor :user_id
  attr_accessor :img

  scope :recent_first, -> { order(created_at: :desc) }

  after_create_commit -> { 
    broadcast_prepend_to :notes_after_create_stream,
      target: :notes_element,
      partial: "notes/note",
      locals: { note: self }
  }

end
