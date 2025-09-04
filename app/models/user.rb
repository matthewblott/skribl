class User < ApplicationRecord
  rolify

  after_create :create_user_database
  after_create :create_user_image_storage
  after_create :assign_default_role

  after_destroy :delete_user_database
  after_destroy :delete_user_image_storage

  private

  def create_user_database
    UserDatabaseService.create_database(self)
  end

  def delete_user_database
    UserDatabaseService.delete_database(self)
  end

  def create_user_image_storage
    user_dir = Rails.root.join('public', 'uploads', "user_#{id.to_s}")
    FileUtils.mkdir_p(user_dir)
    FileUtils.chmod_R(0755, user_dir)
  end

  def delete_user_image

  end

  def delete_user_image_storage
    user_dir = Rails.root.join('public', 'uploads', "user_#{id.to_s}")
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
