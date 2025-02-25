require 'capybara/cuprite'

Capybara.javascript_driver = :cuprite
Capybara.register_driver(:cuprite) do |app|
  Capybara::Cuprite::Driver.new(app, 
    window_size: [1200, 800],
    # See additional options for Dockerized environment in the respective section of this article
    browser_options: {},

    # Enable debugging capabilities
    inspector: true,
    # Allow running Chrome in a headful mode by setting HEADLESS env
    # var to a falsey value
    headless: !ENV['HEADLESS'].in?(%w[n 0 no false])
  )
end

# Configure Capybara to use :cuprite driver by default
Capybara.default_driver = :cuprite
Capybara.javascript_driver = :cuprite
