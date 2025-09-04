class DeleteImagesJob < ApplicationJob
  queue_as :default

  def perform
    User.find_each do |user|
      Note.set_database_connection(user)

      # notes = Note.where(created_at: ..2.weeks.ago)
      notes = Note.where(created_at: ..1.day.ago)

      notes.each do |note|
        DeleteImageJob.perform_later(user.id, note.id)
        note.destroy
      end

    end

  end

end
