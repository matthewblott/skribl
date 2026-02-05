require_relative '../lib/random_line_drawing'

# Create jane user 
user = User.create!(
  email: 'jane@example.com',
  password: 'password12345',
  password_confirmation: 'password12345',
  verified: true
)

# Create notes for jane 
Note.set_database_connection(user)

# Delete the old images 
FileUtils.remove_dir(Rails.root.join('uploads', user.id.to_s))

user_images_dir = Rails.root.join('uploads', user.id.to_s)

80.times do |i|
  note = Note.create!(
    content: "Jane's note #{i+1}: This is a sample note created by Jane. It contains personal thoughts and ideas that Jane wants to remember.",
    image_saved: true
  )

  filename = "#{note.id}.png"

  RandomLineDrawing.generate(
    File.join(user_images_dir, filename)
    # lines: rand(10..30)
  )
end

# Create sally user
sally = User.create!(
  email: 'sally@example.com',
  password: 'password12345',
  password_confirmation: 'password12345',
  verified: true
)

# # Create notes for sally user
Note.set_database_connection(sally)

# Delete the old images 
FileUtils.remove_dir(Rails.root.join('uploads', sally.id.to_s))

sally_images_dir = Rails.root.join('uploads', sally.id.to_s)

30.times do |i|
  note = Note.create!(
    content: "sally note #{i+1}: This is a sample note created by the sally user. It contains some important information that needs to be remembered.",
    image_saved: true
  )

  filename = "#{note.id}.png"

  RandomLineDrawing.generate(
    File.join(sally_images_dir, filename)
    # lines: rand(10..30)
  )
end
