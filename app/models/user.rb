class User < ApplicationRecord
  before_create :generate_totp_secret
  after_create :create_user_database
  after_create :create_user_image_storage

  after_destroy :delete_user_database
  after_destroy :delete_user_image_storage

  def totp
    ROTP::TOTP.new(totp_secret, issuer: "Skribl")
  end

  def generate_totp_secret
    self.totp_secret ||= ROTP::Base32.random_base32
  end

  def valid_otp?(code)
    totp.verify(code, drift_behind: 30)
  end

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

  has_secure_password

  has_many :sessions, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, allow_nil: true, length: { minimum: 12 }

  normalizes :email, with: -> { _1.strip.downcase }
end
