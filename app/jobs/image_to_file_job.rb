class ImageToFileJob < ApplicationJob
  queue_as :default

  def perform(user_id, note_id, image_data)
    file_path = Rails.root.join('uploads', "#{user_id}", "#{note_id}.png")

    image_data = image_data.sub('data:image/png;base64,', '')

    file = File.open(file_path, 'wb')
    file.write(Base64.decode64(image_data))
    file.close

    Apartment::Tenant.switch(user_id.to_s) do
      note = Note.find(note_id)
      note.image_saved = true
      note.save
      note.broadcast_prepend_to(
        "image_notes_#{user_id}",
        target: "user-notes-#{user_id}",
        partial: "notes/note",
        locals: { user_id: user_id, note: note }
      )
    end

  end

end

