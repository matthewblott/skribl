# Skribl

bundle exec vite install

Action cable setup:
rails generate solid_cable:install

rails db:migrate:cable
rails db:migrate:auth
rails db:migrate:tenant

rake apartment:seed

Production:
bin/rails assets:precompile

