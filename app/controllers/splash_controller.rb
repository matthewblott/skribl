class SplashController < ApplicationController
  skip_before_action :authenticate

  def index 
    @redirect_path = send_otp_path

    if Current.user
      @redirect_path = user_notes_path(Current.user)
    end

  end
end
