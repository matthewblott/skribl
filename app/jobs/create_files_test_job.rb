class CreateFilesTestJob < ApplicationJob
  queue_as :default

  def perform
    User.find_each do |user|
      user = User.find_by(id: user.id)

      now = Time.now
      now_string = now.strftime("%Y-%m-%d_%H%M")

      Note.set_database_connection(user)

      # file_path = Rails.root.join('public', 'uploads', "user_#{user.id}", "#{now_string}.txt")
      file_path = Rails.root.join('uploads', "user_#{user.id}", "#{now_string}.txt")
      file = File.open(file_path, 'wb')
      file.write('hello')
      file.close

    end

  end

end
