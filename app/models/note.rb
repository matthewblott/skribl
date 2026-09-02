class Note < ApplicationRecord
  before_create { self.id ||= SecureRandom.uuid }
  validates :content, presence: true
end
