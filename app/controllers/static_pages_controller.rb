class StaticPagesController < ApplicationController
  # skip_before_action :authenticate
  skip_before_action :authenticate_user!

  def splash
    @redirect_path = info_path

    if Current.user
      @redirect_path = user_notes_path(Current.user)
    end

  end

end
