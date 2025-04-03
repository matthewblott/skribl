class ImageToTextJob < ApplicationJob
  queue_as :default

  def perform(user_id, note_id)

    file_path = Rails.root.join('public', 'uploads', "user_#{user_id}", "#{note_id}.png")

    response = ImageToTextConverter.convert(file_path)

    user = User.find_by(id: user_id)

    Note.set_database_connection(user)

    note = Note.find_by(id: note_id)
    note.content = response
    note.save!

  end

end

