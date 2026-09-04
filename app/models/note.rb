class Note < ApplicationRecord
  before_create { self.id ||= SecureRandom.uuid }
  validates :content, presence: true

  attr_accessor :user_id
  attr_accessor :img

  scope :recent_first, -> { order(created_at: :desc) }
end
