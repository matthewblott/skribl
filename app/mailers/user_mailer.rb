require 'base64'

class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def password_reset
    @user = params[:user]
    @signed_id = @user.generate_token_for(:password_reset)

    mail to: @user.email, subject: 'Reset your password'
  end

  def email_verification
    @user = params[:user]
    @signed_id = @user.generate_token_for(:email_verification)

    mail to: @user.email, subject: 'Verify your email'
  end

  def confirmation_email(user)
    @user = user
    @confirmation_url = confirm_user_url(user.confirmation_token)
    
    mail to: @user.email, subject: 'Confirm your account'
  end
  
  def daily_notification(user)
    @user = user
    @image_data = {}

    user_dir = Rails.root.join('public', 'uploads', "user_#{user.id.to_s}")

    notes = Note.where created_at: 384.hours.ago..Time.current

    notes.each do |note|
      filename = "#{user_dir}/#{note.id}.png"

      encoded_image = Base64.strict_encode64(File.read(filename))

      mime_type = "image/png"

      @image_data[filename] = "data:#{mime_type};base64,#{encoded_image}"

      # filename = "#{note.id}.png"
      # attachments.inline[filename] = File.read("#{user_dir}/#{filename}")
      # @image_cids[filename] = "cid:#{filename}"
    end

    mail to: @user.email, subject: 'Daily Notification'

  end

  def test
    mail(from: "test@example.com", to: "user@example.com", subject: "Test", body: "Hello!")
  end

end
