require_relative 'boot'

require 'rails'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'active_job/railtie'
require 'action_cable/engine'

Bundler.require(*Rails.groups)

class ApartmentPathTenant
  def initialize(app)
    @app = app
  end

  def call(env)
    path = env['PATH_INFO']
    first_segment = path.split('/').reject(&:empty?).first

    if first_segment&.match?(/\A\d+\z/)
      Apartment::Tenant.switch(first_segment) do
        @app.call(env)
      end
    else
      @app.call(env)
    end
  end
end

module App 
  class Application < Rails::Application
    config.load_defaults 8.1
    config.autoload_lib(ignore: %w[assets tasks])
    config.generators.system_tests = nil
    config.middleware.use ApartmentPathTenant
  end
end
