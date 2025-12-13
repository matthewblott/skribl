class SessionsController < ApplicationController
  skip_before_action :authenticate, only: %i[ create send_otp validate_otp enter_otp signed_in ]

  before_action :set_session, only: :destroy
  before_action :prevent_caching, only: [:sign_in_success]

  def signed_in
    render json: { signed_in: Current.user.present? }
  end

  def send_otp
    @email = params[:email]
    # @email = 'jane@example.com' if @email.blank?
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
    UserMailer.with(user:, otp_code:).send_otp.deliver_later

    flash[:notice] = "OTP has been sent to #{email}"

    redirect_to enter_otp_path(email: email)
  end

  def enter_otp
    @email = params[:email]
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.valid_otp?(params[:otp_code])
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
    else
      flash.now[:alert] = "Invalid OTP."
      @email = params[:email]
      render :enter_otp, status: :unprocessable_entity
    end

  end
  
  def sign_in_success 
    flash[:notice] = "Signed in successfully"
    @redirect_path = new_user_note_path(Current.user)
  end

  def destroy
    @session.destroy
    flash[:notice] = "That session has been logged out"
    redirect_to send_otp_path
  end

  private

  def set_session
    session_id = cookies.signed[:session_token] || cookies[:session_token]
    return unless session_id

    @session = Session.find_by(id: session_id)
    Current.session = @session
    Current.user = @session&.user
  end

  def prevent_caching
    response.headers["Cache-Control"] = "no-store, no-cache, must-revalidate, max-age=0"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

end
