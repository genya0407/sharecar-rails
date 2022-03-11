require_relative 'boot'

require 'rails'

%w[
  active_record/railtie
  action_controller/railtie
  action_view/railtie
  action_mailer/railtie
  active_job/railtie
  rails/test_unit/railtie
  sprockets/railtie
].each do |railtie|
  require railtie
end

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SharecarRails
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.time_zone = 'Tokyo'
    config.middleware.insert_after ActionDispatch::Static, Rack::Deflater
    config.autoload_paths += ["#{Rails.root}/app/forms"]
    config.active_record.legacy_connection_handling = false
  end
end
