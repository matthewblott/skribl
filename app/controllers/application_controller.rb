class ApplicationController < ActionController::Base
  include Pagy::Backend
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_current_request_details
  before_action :authenticate
  before_action :set_database_connection

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
          cookies.delete(:session_token)
          redirect_to sign_in_path
        end
      rescue => e
        # Log the error but don't expose it to the user
        Rails.logger.error("Authentication error: #{e.message}")
        cookies.delete(:session_token)
        redirect_to sign_in_path
      end
    else
      # No valid session found
      cookies.delete(:session_token)
      redirect_to sign_in_path
    end
  end

  def set_current_request_details
    Current.user_agent = request.user_agent
    Current.ip_address = request.ip
  end

  
  def set_database_connection
    user = Current.user
    return unless user
    Note.set_database_connection(user)
  end

end
