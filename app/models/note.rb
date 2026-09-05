class Note < ApplicationRecord
  before_create { self.id ||= SecureRandom.uuid }
  after_destroy :delete_image
  attr_accessor :img

  scope :recent_first, -> { order(created_at: :desc) }
  
  def delete_image
    DeleteImageJob.perform_later(Current.user.id, self.id)
    broadcast_remove_to(
      "image_notes_#{Current.user.id}",
      target: self
    )
  end
end
