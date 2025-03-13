# frozen_string_literal: true

RSpec.describe Heroku::Api::Postgres::Databases, :vcr do
  let(:oauth_token) { ENV.fetch('HEROKU_OAUTH_TOKEN', nil) }
  let(:client) { Heroku::Api::Postgres.connect_oauth(oauth_token) }

  describe '#info' do
    let(:app_id) { ENV.fetch('VALID_APP_ID_WITH_DATABASE', nil) }
    let(:database_id) { ENV.fetch('VALID_DATABASE_ID_WITH_SCHEDULES', nil) }
    subject(:json_response) { client.databases.info(app_id, database_id) }

    context 'when server returns 404' do
      let(:app_id) { ENV.fetch('VALID_APP_ID_WITH_DATABASE', nil) }
      let(:database_id) { 'whaaaat' }
      it 'returns an error in json format' do
        expect(json_response[:error][:status]).to eq 404
      end
    end

    context 'when server returns 200' do
      it 'returns all information of a database' do
        expect(json_response.length).to eq 12
        expect(json_response[:addon_id]).to eq ENV.fetch('VALID_DATABASE_ID_WITH_SCHEDULES', nil)
        expect(json_response[:name]).not_to be_nil
      end
    end

    context 'when database is on a pro plan' do
      let(:app_id) { ENV.fetch('VALID_APP_ID_WITH_DB_IN_PRO_PLAN', nil) }
      let(:database_id) { ENV.fetch('VALID_DATABASE_ID_WITH_PRO_PLAN', nil) }

      it 'returns all information of a database' do
        expect(json_response.length).to eq 27
        expect(json_response[:addon_id]).to eq ENV.fetch('VALID_DATABASE_ID_WITH_PRO_PLAN', nil)
        expect(json_response[:name]).not_to be_nil
      end
    end
  end

  describe '#wait' do
    let(:app_id) { ENV.fetch('VALID_APP_ID_WITH_DATABASE', nil) }
    let(:database_id) { ENV.fetch('VALID_DATABASE_ID_WITH_SCHEDULES', nil) }
    subject(:json_response) { client.databases.wait(app_id, database_id, wait_interval: 4) }

    context 'when server returns 200' do
      it 'waits for the given database to be available and returns the database' do
        expect(json_response[:addon_id]).to eq ENV.fetch('VALID_DATABASE_ID_WITH_SCHEDULES', nil)
        expect(json_response[:name]).not_to be_nil
      end
    end
  end
end
