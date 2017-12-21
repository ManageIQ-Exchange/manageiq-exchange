require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ManageiqGalaxy
  class Application < Rails::Application
    config.api_version = '1.0'
    config.api_prefix  = 'v1'

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.autoload_paths << root.join('lib','v1').expand_path
    config.autoload_paths << root.join('lib').expand_path
    # Adding back session store in cookies, so that it is possible to create and destroy sessions

    # config.session_store :cookie_store, key: '_miq_galaxy_session'
    # config.middleware.use ActionDispatch::Cookies # Required for all session management
    # config.middleware.use ActionDispatch::Session::CookieStore, config.session_options
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options, :delete]
      end
    end
    I18n.available_locales = [:en]
    config.i18n.default_locale = :en

    config.generators do |g|
      g.test_framework :rspec #=> or whatever
    end

    #
    # Loading JSON Schemas
    #
    config.spin_schema = JSON.load File.new("app/schemas/metadata.json")
  end
end
