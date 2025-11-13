class BaseController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern

  # before_action :set_current_request_details
  # before_action :set_database_connection
  #
  # private
  #
  # def set_current_request_details
  #   token = Rails.env.test? ? cookies[:session_token] : cookies.signed[:session_token]
  #
  #   return unless token.present?
  #
  #   session_record = Session.find_by_id(token)
  #
  #   if session_record&.user_id
  #     user = User.find_by(id: session_record.user_id)
  #     if user
  #       Current.user_agent = request.user_agent
  #       Current.ip_address = request.ip
  #       Current.session = session_record
  #       Current.user = user
  #     else
  #       # Clean up invalid session
  #       session_record.destroy
  #       cookies.delete(:session_token)
  #     end
  #   else
  #     cookies.delete(:session_token)
  #   end
  # end
  #
  # def set_database_connection
  #   user = Current.user
  #   return unless user
  #   Note.set_database_connection(user)
  # end

end
