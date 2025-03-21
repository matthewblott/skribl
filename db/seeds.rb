require_relative '../lib/random_line_drawing'

# Create admin user
admin = User.create!(
  email: 'admin@example.com',
  password: 'password12345',
  password_confirmation: 'password12345',
  verified: true
)
admin.add_role(:admin)

# Create regular user
user = User.create!(
  email: 'jane@example.com',
  password: 'password12345',
  password_confirmation: 'password12345',
  verified: true
)

# # Create notes for admin user
Note.set_database_connection(admin)

# Delete the old images 
FileUtils.remove_dir(Rails.root.join('public', 'uploads', "user_#{admin.id}"))

admin_images_dir = Rails.root.join('public', 'uploads', "user_#{admin.id}")

30.times do |i|
  note = Note.create!(
    content: "Admin note #{i+1}: This is a sample note created by the admin user. It contains some important information that needs to be remembered."
  )

  filename = "#{note.id}.png"

  RandomLineDrawing.generate(
    File.join(admin_images_dir, filename),
    lines: rand(10..30)
  )
end

# Create notes for jane 
Note.set_database_connection(user)

# Delete the old images 
FileUtils.remove_dir(Rails.root.join('public', 'uploads', "user_#{user.id}"))

user_images_dir = Rails.root.join('public', 'uploads', "user_#{user.id}")

20.times do |i|
  note = Note.create!(
    content: "Jane's note #{i+1}: This is a sample note created by Jane. It contains personal thoughts and ideas that Jane wants to remember."
  )

  filename = "#{note.id}.png"

  RandomLineDrawing.generate(
    File.join(user_images_dir, filename),
    lines: rand(10..30)
  )
end
