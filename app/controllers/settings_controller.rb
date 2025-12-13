require 'zip'

class SettingsController < ApplicationController
  def destroy
    @user = User.find(Current.user.id)
    @user.destroy

    Current.session.destroy
    flash[:notice] = "Your account has been deleted."
    redirect_to send_otp_path
  end

  def download_images_old
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

    # redirect_to settings_path

  end

  def download_images
    name = 'myfile'
    extension = 'zip'
    filename = "#{name}.#{extension}"

    folder_path = Rails.root.join('uploads', Current.user.id.to_s)
    path = Rails.root.join(folder_path, filename)
    send_file path,
      filename: filename,
      # type: 'text/plain',
      type: 'application/zip'
      # type: 'image/png'
      # , disposition: 'attachment'
  end

end
