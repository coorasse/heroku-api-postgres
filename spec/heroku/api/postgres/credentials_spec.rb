# frozen_string_literal: true

RSpec.describe Heroku::Api::Postgres::Credentials, :vcr do
  let(:oauth_token) { ENV.fetch('HEROKU_OAUTH_TOKEN', nil) }
  let(:client) { Heroku::Api::Postgres.connect_oauth(oauth_token) }

  describe '#rotate' do
    let(:app_id) { ENV.fetch('VALID_APP_ID_WITH_DATABASE', nil) }
    let(:database_id) { ENV.fetch('VALID_DATABASE_ID_WITH_SCHEDULES', nil) }
    subject(:json_response) { client.credentials.rotate(app_id, database_id) }

    context 'server returns 404' do
      let(:database_id) { 'whaaaat' }
      it 'returns an error in json format' do
        expect(json_response[:error][:status]).to eq 404
      end
    end

    context 'server returns 200' do
      it 'returns the success message' do
        expect(json_response[:message]).to eq "Rotating credentials on #{database_id}"
      end
    end
  end
end
