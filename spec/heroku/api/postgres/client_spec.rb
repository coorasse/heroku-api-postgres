# frozen_string_literal: true

RSpec.describe Heroku::Api::Postgres::Client, :vcr do
  let(:app_id) { ENV.fetch('VALID_APP_ID_WITH_DATABASE', nil) }
  let(:database_id) { ENV.fetch('VALID_DATABASE_ID_WITH_SCHEDULES', nil) }

  describe '.connect_oauth' do
    let(:oauth_token) { ENV.fetch('HEROKU_OAUTH_TOKEN', nil) }
    it {
      expect do
        Heroku::Api::Postgres.connect_oauth(oauth_token).databases.info(app_id, database_id)
      end.not_to raise_error
    }
  end

  describe '.connect' do
    let(:api_key) { ENV.fetch('HEROKU_API_KEY', nil) }
    it { expect { Heroku::Api::Postgres.connect(api_key).databases.info(app_id, database_id) }.not_to raise_error }
  end
end
