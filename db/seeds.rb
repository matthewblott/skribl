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

# Create notes for admin user
Note.set_database_connection(admin)
30.times do |i|
  Note.create!(
    title: "",
    content: "Admin note #{i+1}: This is a sample note created by the admin user. It contains some important information that needs to be remembered."
  )
end

Note.set_database_connection(user)

20.times do |i|
  Note.create!(
    title: "",
    content: "Jane's note #{i+1}: This is a sample note created by Jane. It contains personal thoughts and ideas that Jane wants to remember."
  )
end
