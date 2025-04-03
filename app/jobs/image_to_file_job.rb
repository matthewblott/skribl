class ImageToFileJob < ApplicationJob
  queue_as :default

  def perform(user_id, note_id, image_data)
    file_path = Rails.root.join('public', 'uploads', "user_#{user_id}", "#{note_id}.png")

    image_data = image_data.sub('data:image/png;base64,', '')

    file = File.open(file_path, 'wb')
    file.write(Base64.decode64(image_data))
    file.close
    
    ImageToTextJob.perform_later(user_id, note_id) 
  end

end
