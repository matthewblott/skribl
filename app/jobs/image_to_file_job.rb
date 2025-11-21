class ImageToFileJob < ApplicationJob
  queue_as :default

  def perform(user_id, note_id, image_data)
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

    Turbo::StreamsChannel.broadcast_update_to(
      :created_note_stream,
      target: "note_#{note_id}",
      partial: "notes/note_link",
      locals: { user_id: user_id, note_id: note_id }
    )

  end

end
