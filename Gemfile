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
gem 'rack'
gem 'rails', '8.0.3'
gem 'requestjs-rails'
gem 'rolify'
gem "rotp", "~> 6.3"
gem 'solid_cable'
gem 'solid_cache'
gem 'solid_queue'
gem 'sqlite3', '>= 2.1'
gem 'stimulus-rails'
gem 'thruster', require: false
gem 'turbo-rails'

group :development, :test do
  gem 'brakeman', require: false
  gem 'bullet' # Not compatible with 8.1
  # gem 'debug', platforms: %i[ mri ], require: 'debug/prelude'
  gem 'debug', platforms: %i[ mri ] 
  # gem 'debase'
  # gem 'debase-ruby_core_source'
  # gem 'ruby-debug-ide'
  # gem 'mutex_m' 
  gem 'debase', '>= 0.2.4.1'
  gem 'ruby-debug-ide', '>= 0.7.0' 
end

group :development do
  gem 'hotwire-spark', '~> 0.1'
  gem 'web-console'
  gem 'letter_opener'
end

group :test do
  gem 'capybara'
  gem 'cuprite'
  gem 'database_cleaner-active_record'
  gem 'factory_bot_rails', '~> 6.4'
  gem 'guard'
  gem 'guard-rspec'
  gem 'mini_magick'
  gem 'rspec-rails'
  gem 'shoulda-matchers', '~> 6.4'
end
