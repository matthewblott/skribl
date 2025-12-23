require 'zip'

class SettingsController < ApplicationController
  # skip_before_action :authenticate, only: [:download_images]

  def destroy
    @user = User.find(Current.user.id)
    @user.destroy

    Current.session.destroy
    flash[:notice] = "Your account has been deleted."
    redirect_to send_otp_path
  end

  def download_images
    folder_path = Rails.root.join('uploads', Current.user.id.to_s)
    zip_data = Zip::OutputStream.write_buffer do |zip|
      Dir.glob("#{folder_path}/*.png").each do |file|
        zip.put_next_entry(File.basename(file))
        zip.write(File.read(file))
      end
    end

    send_data zip_data.string, 
      filename: 'images.zip', 
      type: 'application/zip'

  end

end
