require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build(:user) }

    # Email validations
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }

    describe 'email uniqueness' do
      it 'prevents creation of users with duplicate emails' do
        existing_user = create(:user, email: 'test@example.com')
        new_user = build(:user, email: 'test@example.com')
        expect(new_user).not_to be_valid
        expect(new_user.errors[:email]).to include('has already been taken')
      end

      it 'is case-insensitive for email uniqueness' do
        existing_user = create(:user, email: 'test@example.com')
        new_user = build(:user, email: 'TEST@EXAMPLE.COM')
        expect(new_user).not_to be_valid
        expect(new_user.errors[:email]).to include('has already been taken')
      end

      it 'is sensitive to different email addresses' do
        existing_user = create(:user, email: 'test@example.com')
        new_user = build(:user, email: 'test@different.com')
        expect(new_user).to be_valid
      end

      it 'handles whitespace in email addresses' do
        existing_user = create(:user, email: 'test@example.com')
        new_user = build(:user, email: ' test@example.com ')
        expect(new_user).not_to be_valid
        expect(new_user.errors[:email]).to include('has already been taken')
      end
    end

    it 'validates email format' do
      user = build(:user)
      
      valid_emails = ['user@example.com', 'user.name@example.co.uk', 'user+label@example.com']
      invalid_emails = ['user@', '@example.com', 'user@.com', 'user@example.', 'userexample.com']

      valid_emails.each do |email|
        user.email = email
        expect(user).to be_valid
      end

      invalid_emails.each do |email|
        user.email = email
        expect(user).not_to be_valid
      end
    end

    # Password validations
    context 'password validations' do
      it 'validates minimum password length' do
        user = build(:user)
        user.password = user.password_confirmation = 'short'
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include('is too short (minimum is 12 characters)')

        user.password = user.password_confirmation = 'long_enough_password'
        expect(user).to be_valid
      end
    end

    it 'requires password on create' do
      user = build(:user, password: nil, password_confirmation: nil)
      expect(user).not_to be_valid
    end

    it 'does not require password on update' do
      user = create(:user)
      user.email = 'new@example.com'
      expect(user).to be_valid
    end
  end

  describe 'email normalization' do
    it 'normalizes email before validation' do
      user = create(:user, email: ' USER@EXAMPLE.COM ')
      expect(user.email).to eq('user@example.com')
    end
  end

  describe 'email verification' do
    it 'resets verified status when email is changed' do
      user = create(:user, verified: true)
      expect(user.verified).to be true

      user.update(email: 'new@example.com')
      expect(user.verified).to be false
    end

    it 'does not reset verified status when other attributes change' do
      user = create(:user, verified: true)
      user.update(password: 'new_password12345', password_confirmation: 'new_password12345')
      expect(user.verified).to be true
    end
  end

  describe 'session management' do
    it 'deletes other sessions when password changes' do
      user = create(:user)
      session1 = user.sessions.create!
      session2 = user.sessions.create!
      
      Current.session = session1

      user.update(password: 'new_password12345', password_confirmation: 'new_password12345')
      
      expect(user.sessions.count).to eq(1)
      expect(user.sessions.first).to eq(session1)
    end
  end

  describe 'roles' do
    it 'assigns default role on creation' do
      user = create(:user)
      expect(user.has_role?(:user)).to be true
    end

    it 'can be assigned admin role' do
      admin = create(:admin_user)
      expect(admin.has_role?(:admin)).to be true
    end
  end

  describe 'database creation' do
    it 'creates a user database on creation' do
      user = create(:user)
      db_path = "storage/#{Rails.env}_user_#{user.id}.sqlite3"
      expect(File.exist?(db_path)).to be true
    end
  end
end
