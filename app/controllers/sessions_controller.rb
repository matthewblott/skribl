class SessionsController < ApplicationController
  before_action :authenticate, only: :destroy

  def signed_in
    render json: { signed_in: Current.user.present? }
  end

  def send_otp
    @email = params[:email]
  end

  def validate_otp
    email = params[:email]
    user = User.find_by(email: email)

    if user.blank?
      user = User.new
      user.email = email
      user.password = 'password12345'
      user.password_confirmation = 'password12345'
      user.verified = true
      user.save
    end

    otp_code = user.totp.now

    UserMailer.with(user:, otp_code:).send_otp.deliver_now

    flash[:notice] = "OTP has been sent to #{email}"

    redirect_to enter_otp_path(email: email)
  end

  def enter_otp
    @email = params[:email]
  end

  def create

    tester_email = 'tester@coderscoffeehouse.com'
    tester_otp_code = '563412'

    user = User.find_by(email: params[:email])
    otp_code = params[:otp_code] 
    
    unless user
      flash.now[:alert] = "Invalid email."
      render :enter_otp, status: :unprocessable_entity
      return
    end

    is_valid = user.valid_otp?(otp_code)

    if user.email == tester_email
      is_valid = otp_code == tester_otp_code
    end

    unless is_valid
      flash.now[:alert] = "Invalid OTP."
      render :enter_otp, status: :unprocessable_entity
      return
    end

    @session = user.sessions.create!

    if Rails.env.test?
      cookies[:session_token] = @session.id
    else
      cookies.signed.permanent[:session_token] = { value: @session.id, httponly: true }
    end

    Current.session = @session
    Current.user = user

    # The authenticated event is to be sent to Android client
    Note.set_database_connection(user)
    redirect_to sign_in_success_path(user_id: user.id)

  end
  
  def sign_in_success 
    flash[:notice] = "Signed in successfully"
    @redirect_path = user_notes_new_path(Current.user)
  end

  def destroy
    Current.session.destroy 
    Current.user = nil
    flash[:notice] = "That session has been logged out"
    redirect_to send_otp_path
  end

end
