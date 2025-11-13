class User < ApplicationRecord
  rolify
  before_create :generate_totp_secret

  after_create :create_user_database
  after_create :create_user_image_storage
  after_create :assign_default_role

  after_destroy :delete_user_database
  after_destroy :delete_user_image_storage


  def totp
    ROTP::TOTP.new(totp_secret, issuer: "Scribble")
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

  # path = Rails.root.join("uploads", "user_#{user_id}", file)

  def create_user_image_storage
    # user_dir = Rails.root.join('public', 'uploads', "user_#{id.to_s}")
    user_dir = Rails.root.join('uploads', "#{id.to_s}")
    FileUtils.mkdir_p(user_dir)
    FileUtils.chmod_R(0755, user_dir)
  end

  def delete_user_image

  end

  def delete_user_image_storage
    # user_dir = Rails.root.join('public', 'uploads', "user_#{id.to_s}")
    user_dir = Rails.root.join('uploads', "#{id.to_s}")
    # debugger
    FileUtils.rm_rf(user_dir)
  end

  def assign_default_role
    add_role(:user) if roles.blank?
  end

  has_secure_password

  generates_token_for :email_verification, expires_in: 2.days do
    email
  end

  generates_token_for :password_reset, expires_in: 20.minutes do
    password_salt.last(10)
  end


  has_many :sessions, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, allow_nil: true, length: { minimum: 12 }

  normalizes :email, with: -> { _1.strip.downcase }

  before_validation if: :email_changed?, on: :update do
    self.verified = false
  end

  after_update if: :password_digest_previously_changed? do
    sessions.where.not(id: Current.session).delete_all
  end

end
