RSpec.describe Heroku::Api::Postgres::Client, :vcr do
  let(:oauth_token) { ENV['HEROKU_OAUTH_TOKEN'] }
  let(:client) { Heroku::Api::Postgres.connect_oauth(oauth_token) }

  describe '#wait' do
    let(:database_id) { ENV['VALID_DATABASE_ID_WITH_SCHEDULES'] }
    subject(:json_response) { client.wait(database_id, wait_interval: 4) }

    context 'server returns 200' do
      it 'waits for the given database to be available and returns the database' do
        expect(json_response[:addon_id]).to eq ENV['VALID_DATABASE_ID_WITH_SCHEDULES']
        expect(json_response[:name]).not_to be_nil
      end
    end
  end
end
