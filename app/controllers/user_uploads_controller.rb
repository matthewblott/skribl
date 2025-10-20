class UserUploadsController < ApplicationController
  # before_action :authenticate_user!

  def show
    user_id = params[:user_id].to_i
    file = params[:filename]

    # Ensure the current user can only access their own files
    if user_id != Current.user.id
      head :forbidden and return
    end

    path = Rails.root.join("uploads", "#{user_id}", "#{file}.png")
    
    # debugger

    if File.exist?(path)
      send_file path, disposition: "inline", type: "image/png"
    else
      head :not_found
    end
  end
end

