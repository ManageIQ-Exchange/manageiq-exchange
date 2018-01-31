# This file is copied to spec/ when you run 'rails generate rspec:install'
# require database cleaner at the top level
require 'database_cleaner'

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

VCR.configure do |config|
  config.cassette_library_dir = File.join(Rails.root, 'spec/vcr_cassettes')
  config.hook_into :webmock
  config.filter_sensitive_data('CLIENT-ID') do |interaction|
    (Rack::Utils.parse_query URI(interaction.request.uri).query)['client_id']
  end
  config.filter_sensitive_data('CLIENT-SECRET') do |interaction|
    (Rack::Utils.parse_query URI(interaction.request.uri).query)['client_secret']
  end
  config.filter_sensitive_data('GITHUB-TOKEN') do |interaction|
    if interaction.response.body.is_a?(Hash)
      JSON.parse(interaction.response.body)['access_token'] if interaction.response.body.has_key? 'access_token'
    end
  end
  config.filter_sensitive_data('AUTHENTICATION-TOKEN') do |interaction|
    if interaction.response.body.is_a?(Hash)
      data = JSON.parse(interaction.response.body)['data']
      data['authentication_token'] if data
    end
  end

  config.configure_rspec_metadata!
  config.default_cassette_options = {
      match_requests_on: [:method,
                          VCR.request_matchers.uri_without_param(:client_id, :client_secret, :access_token)]
  }
  # config.debug_logger = File.open("log/github_connection.log", 'w')
end
# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  config.include Spec::Support::Api::Helpers, :type => :request
  config.include Spec::Support::Api::Helpers, :type => :model
  config.include Spec::Support::Api::RequestHelpers, :type => :request
  config.include Spec::Support::Api::RequestHelpers, :type => :model
  config.include Serializers::SerializeHelpers, type: :serializer
  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  # start by truncating all the tables but then use the faster transaction strategy the rest of the time.
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :transaction
  end
  # start the transaction strategy as examples are run
  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
