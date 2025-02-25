class Note < UserRecord

  validates :title, presence: true, length: { maximum: 255 }
  validates :content, presence: true

  before_save :strip_whitespace

  private

  def strip_whitespace
    self.title = title.strip if title.present?
    self.content = content.strip if content.present?
  end
end
