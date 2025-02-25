RSpec.shared_context "clean note databases" do
  before(:each) do
    # Clean the current user's note database
    Note.set_database_connection(user)
    Note.delete_all
  end

  after(:each) do
    # Clean up any other user databases that might have been created
    User.where.not(id: user.id).find_each do |other_user|
      Note.set_database_connection(other_user)
      Note.delete_all
    end
    # Switch back to the main test user's database
    Note.set_database_connection(user)
  end
end

RSpec.configure do |config|
  config.include_context "clean note databases", type: :request
end
