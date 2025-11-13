class ApplicationController < BaseController
  include Pagy::Backend

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern

  before_action :set_current_request_details
  before_action :set_database_connection
  before_action :authenticate

  private

  def authenticate
    token = Rails.env.test? ? cookies[:session_token] : cookies.signed[:session_token]

    if token.present? && (session_record = Session.find_by_id(token))
      begin
        if session_record.user_id && (user = User.find_by(id: session_record.user_id))
          Current.session = session_record
          Current.user = user
        else
          # Invalid user_id or user not found, clean up the session
          session_record.destroy
          redirect_to_sign_in
        end
      rescue => e
        # Log the error but don't expose it to the user
        Rails.logger.error("Authentication error: #{e.message}")
        redirect_to_sign_in
      end
    else
      # No valid session found
      redirect_to_sign_in
    end
  end

  def redirect_to_sign_in
    cookies.delete(:session_token)
    redirect_to send_otp_path
  end

  def set_current_request_details
    token = Rails.env.test? ? cookies[:session_token] : cookies.signed[:session_token]

    return unless token.present?

    session_record = Session.find_by_id(token)

    if session_record&.user_id
      user = User.find_by(id: session_record.user_id)
      if user
        Current.user_agent = request.user_agent
        Current.ip_address = request.ip
        Current.session = session_record
        Current.user = user
      else
        # Clean up invalid session
        session_record.destroy
        cookies.delete(:session_token)
      end
    else
      cookies.delete(:session_token)
    end
  end

  def set_database_connection
    user = Current.user
    return unless user
    Note.set_database_connection(user)
  end


end
