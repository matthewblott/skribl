class User < ApplicationRecord
  after_create :create_user_database
  after_create :create_user_image_storage

  after_destroy :delete_user_database
  after_destroy :delete_user_image_storage

  before_validation :generate_device_token, on: :create

  validates :device_token, presence: true, uniqueness: true

  private

  def create_user_database
    UserDatabaseService.create_database(self)
  end

  def delete_user_database
    UserDatabaseService.delete_database(self)
  end

  def create_user_image_storage
    user_dir = Rails.root.join('uploads', "#{id.to_s}")
    FileUtils.mkdir_p(user_dir)
    FileUtils.chmod_R(0755, user_dir)
  end

  def delete_user_image_storage
    user_dir = Rails.root.join('uploads', "#{id.to_s}")
    FileUtils.rm_rf(user_dir)
  end

  def generate_device_token
    self.device_token ||= SecureRandom.urlsafe_base64(32)
  end
end
