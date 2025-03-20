source 'https://rubygems.org'

ruby File.read('.ruby-version').strip

gem 'authentication-zero', '~> 4.0'
gem 'bcrypt', '~> 3.1'
gem 'bootsnap', require: false
gem 'cancancan'
gem 'faker'
gem 'image_processing', '~> 1.2'
gem 'importmap-rails'
gem 'pagy', '~> 9.3'
gem 'propshaft'
gem 'puma', '>= 5.0'
gem 'rails', '~> 8.0'
gem 'requestjs-rails'
gem 'rolify'
gem 'solid_cable'
gem 'solid_cache'
gem 'solid_queue'
gem 'sqlite3', '>= 2.1'
gem 'stimulus-rails'
gem 'tailwindcss-rails'
gem 'thruster', require: false
gem 'turbo-rails'

group :development, :test do
  gem 'brakeman', require: false
  gem 'bullet'
  gem 'debug', platforms: %i[ mri ], require: 'debug/prelude'
end

group :development do
  gem 'hotwire-spark', '~> 0.1'
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'cuprite'
  gem 'database_cleaner-active_record'
  gem 'factory_bot_rails', '~> 6.4'
  gem 'guard'
  gem 'guard-rspec'
  gem 'rspec-rails'
  gem 'shoulda-matchers', '~> 6.4'
end
