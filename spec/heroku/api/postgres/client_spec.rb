# frozen_string_literal: true

RSpec.describe Heroku::Api::Postgres::Client, :vcr do
  let(:oauth_token) { ENV['HEROKU_OAUTH_TOKEN'] }
  let(:client) { Heroku::Api::Postgres.connect_oauth(oauth_token) }
end
