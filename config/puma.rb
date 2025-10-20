# config/puma.rb

# Root of the app, relative to this file
app_root = File.expand_path("../..", __FILE__)

# Set Rails environment
environment ENV.fetch("RAILS_ENV") { "development" }

# Change to the app directory
directory app_root

# Bind depending on environment
if ENV["RAILS_ENV"] == "production"
  bind "unix://#{app_root}/tmp/sockets/puma.sock"
else
  port ENV.fetch("PORT") { 3000 }
end

# File paths for PID and state
pidfile "#{app_root}/tmp/pids/puma.pid"
state_path "#{app_root}/tmp/pids/puma.state"

# Logging (optional, but helps)
# stdout_redirect "#{app_root}/log/puma.stdout.log", "#{app_root}/log/puma.stderr.log", true

# Threads/workers — standard defaults
threads_count = ENV.fetch("RAILS_MAX_THREADS", 5)
threads threads_count, threads_count

workers ENV.fetch("WEB_CONCURRENCY", 0)

# Use tmp/restart.txt (used by touch tmp/restart.txt in Passenger or Capistrano setups)
plugin :tmp_restart
