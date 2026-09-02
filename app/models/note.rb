class Note < ApplicationRecord
  before_create { self.id ||= SecureRandom.uuid }
  validates :title, presence: true, length: { maximum: 25 }
  validates :details, presence: true, length: { maximum: 250 }
end
