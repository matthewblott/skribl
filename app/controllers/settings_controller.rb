class SettingsController < ApplicationController
  def index
  end

  def destroy
    @user = User.find(Current.user.id)
    @user.destroy

    Current.session.destroy
    flash[:notice] = "Your account has been deleted."
    redirect_to send_otp_path
  end

end
