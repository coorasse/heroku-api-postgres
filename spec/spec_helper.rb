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

  # Removes all private data (Basic Auth, Set-Cookie headers...)
  config.before_record do |i|
    i.request.headers.delete('Authorization')
    i.response.body.gsub!(%r((postgres:\/\/)([^\"]*)"), '\1username:password@database_url:port/schema_name"')
    i.response.body.gsub!(%r((https:\/\/)([^\.]*)(\.s3\.amazonaws\.com)([^\"]*)), '\1bucket_name\3/resource_address')
    i.response.body.gsub!(%r((\"database_user\":\")([^\"]*)"), '\1username"')
    i.response.body.gsub!(%r((\"database_name\":\")([^\"]*)"), '\1schema_name"')
    i.response.body.gsub!(%r((\"uuid\":\")([^\"]*)"), '\182ead067-7608-f587-cf6f-d351ba6b684c"')
  end
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
