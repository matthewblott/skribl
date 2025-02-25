# Create roles in main database
Role.find_or_create_by(name: 'admin')
Role.find_or_create_by(name: 'user')

# Create or update admin user in main database
admin = User.find_or_create_by(email: 'admin@example.com')
admin.update!(
  password: 'password12345',
  password_confirmation: 'password12345',
  verified: true
)

# Ensure admin has admin role
admin.add_role(:admin) unless admin.has_role?(:admin)

# Create and migrate admin's database
system("RAILS_ENV=#{Rails.env} USER_ID=#{admin.id} rails db:migrate_user")

# Add notes to admin's database
Note.connected_to(database: { writing: :user_specific }, user_id: admin.id) do
  3.times do |i|
    Note.find_or_create_by(title: "Admin Note #{i + 1}") do |note|
      note.content = "This is admin's note #{i + 1}"
    end
  end
end

# Create or update regular user in main database
user = User.find_or_create_by(email: 'jane@example.com')
user.update!(
  password: 'password12345',
  password_confirmation: 'password12345',
  verified: true
)

# Create and migrate user's database
system("RAILS_ENV=#{Rails.env} USER_ID=#{user.id} rails db:migrate_user")

# Add notes to user's database
Note.connected_to(database: { writing: :user_specific }, user_id: user.id) do
  3.times do |i|
    Note.find_or_create_by(title: "User Note #{i + 1}") do |note|
      note.content = "This is user's note #{i + 1}"
    end
  end
end
