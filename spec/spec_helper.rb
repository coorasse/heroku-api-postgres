require 'dotenv/load'
require 'bundler/setup'
require 'heroku/api/postgres'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.filter_sensitive_data('<HEROKU_OAUTH_TOKEN>') { ENV['HEROKU_OAUTH_TOKEN'] }
  config.filter_sensitive_data('<VALID_DATABASE_ID_WITH_SCHEDULES>') { ENV['VALID_DATABASE_ID_WITH_SCHEDULES'] }
  config.filter_sensitive_data('<VALID_APP_ID>') { ENV['VALID_APP_ID'] }
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
