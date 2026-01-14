require 'base64'

class UserMailer < ApplicationMailer
  default from: 'notifications@matthewblott.com'

  def send_otp
    @user = params[:user]
    @otp_code = params[:otp_code]

    mail(
      to: @user.email,
      subject: "#{@otp_code} - Your Skribl one-time code"
    )

  end

end
