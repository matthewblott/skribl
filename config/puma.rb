app_root = File.expand_path('../..', __FILE__)

environment ENV.fetch('RAILS_ENV') { 'development' }

directory app_root
pidfile "#{app_root}/tmp/pids/puma.pid"
state_path "#{app_root}/tmp/pids/puma.state"
stdout_redirect "#{app_root}/log/puma.stdout.log", "#{app_root}/log/puma.stderr.log", true

threads_count = Integer(ENV.fetch('RAILS_MAX_THREADS', 5))
threads threads_count, threads_count

workers Integer(ENV.fetch('WEB_CONCURRENCY', 0))

# plugin :tmp_restart is also handy for Capistrano-style deploys
plugin :tmp_restart

cert_path = File.join(app_root, 'localhost.pem')
key_path  = File.join(app_root, 'localhost-key.pem')

if ENV['RAILS_ENV'] == 'production'
  bind "unix://#{app_root}/tmp/sockets/puma.sock"
elsif File.exist?(cert_path) && File.exist?(key_path)
  ssl_bind 'localhost', 3000, key: key_path, cert: cert_path
else
  port ENV.fetch('PORT') { 3000 }
end
