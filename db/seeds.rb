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
