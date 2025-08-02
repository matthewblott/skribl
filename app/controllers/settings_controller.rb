class SettingsController < ApplicationController

  def destroy
    @user = User.find(Current.user.id)
    @user.destroy

    Current.session.destroy
    redirect_to sign_in_path 
  end

end
