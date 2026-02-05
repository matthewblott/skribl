class ApplicationController < ActionController::Base
  include Pagy::Backend

  before_action :set_current_request_details
  before_action :set_database_connection
  before_action :authenticate

  private

  def authenticate
    unless @token.present? && @session_record && @user
      redirect_to send_otp_path
    end
  end

  def set_current_request_details
    @token = Rails.env.test? ? cookies[:session_token] : cookies.signed[:session_token]

    return unless @token.present?

    @session_record = Session.find_by_id(@token)

    return unless @session_record

    @user = User.find_by(id: @session_record.user_id)

    return unless @user

    Current.user_agent = request.user_agent
    Current.ip_address = request.ip
    Current.session = @session_record
    Current.user = @user
  end

  def set_database_connection
    user = Current.user
    return unless user
    Note.set_database_connection(user)
  end

end
