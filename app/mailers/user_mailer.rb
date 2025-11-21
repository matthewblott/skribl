require 'base64'

class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def daily_notification(user)
    @user = user
    @image_data = {}

    user_dir = Rails.root.join('uploads', "user_#{user.id.to_s}")

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

  def send_otp
    @user = params[:user]
    @otp_code = params[:otp_code]

    mail(
      to: @user.email,
      subject: "#{@otp_code} - Your Scribble one-time code"
    )

    # Rails.logger.info "DEBUG OTP for #{user.email}: #{otp_code}" # for testing

  end

end
