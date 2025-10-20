class DeleteImageJob < ApplicationJob
  queue_as :default

  def perform(user_id, note_id)
    # file_path = Rails.root.join('public', 'uploads', "user_#{user_id}", "#{note_id}.png")
    file_path = Rails.root.join('uploads', "#{user_id}", "#{note_id}.png")
    File.delete(file_path)
  end

end
