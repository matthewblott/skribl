class ApplicationController < ActionController::Base
  include ApplicationHelper
  helper_method :is_native_app?

  allow_browser versions: :modern
  before_action :load_current_user
  before_action :authenticate_user!
  before_action :authorize_user!

  private

  def load_current_user
    session_record = Session.find_by_id(cookies.signed[:session_token])

    unless session_record.nil? 
      Current.session = session_record
      Current.user = session_record.user
      return
    end

    token = cookies.encrypted[:device_token]

    unless token.present?
      return
    end

    user = User.find_by(device_token: token)

    unless user
      return
    end

    Current.user = user
  end

  def authenticate_user!
    if Current.user
      return
    end

    redirect_to info_path
  end

  def authorize_user!
    unless params[:user_id].present?
      return
    end
    
    if Current.user.id == params[:user_id].to_i
      return
    end

    redirect_to home_path, alert: "Not authorised."
  end

end
