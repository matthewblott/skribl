class ImageToFileJob < ApplicationJob
  queue_as :default

  def perform(user_id, note_id, image_data)
    # file_path = Rails.root.join('public', 'uploads', "user_#{user_id}", "#{note_id}.png")
    file_path = Rails.root.join('uploads', "#{user_id}", "#{note_id}.png")

    image_data = image_data.sub('data:image/png;base64,', '')

    file = File.open(file_path, 'wb')
    file.write(Base64.decode64(image_data))
    file.close

    user = User.find(user_id)
    Note.set_database_connection(user)
    note = Note.find(note_id)
    note.image_saved = true
    note.save

    html_string = "<a href='/#{user_id}/notes/#{note_id}'>"
    html_string += "<img src='/uploads/#{user_id}/#{note_id}.png'>"
    html_string += "</a>"

    Turbo::StreamsChannel.broadcast_update_to(
      :created_note,
      # :notes_user,
      target: "note_#{note_id}",
      html: html_string
    )

    # ImageToTextJob.perform_later(user_id, note_id) 
  end

end
