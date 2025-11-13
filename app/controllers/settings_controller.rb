class SettingsController < ApplicationController
  def index
  end

  def destroy
    @user = User.find(Current.user.id)
    @user.destroy

    Current.session.destroy
    flash[:notice] = "Your account has been deleted."
    redirect_to sign_in_path 
  end

end
