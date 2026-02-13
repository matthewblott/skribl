require 'zip'

class SettingsController < ApplicationController

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
