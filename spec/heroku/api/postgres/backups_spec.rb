RSpec.describe Heroku::Api::Postgres::Backups, :vcr do
  let(:oauth_token) { ENV['HEROKU_OAUTH_TOKEN'] }
  let(:client) { Heroku::Api::Postgres.connect_oauth(oauth_token) }

  describe '#list' do
    let(:app_id) { ENV['VALID_APP_ID'] }
    subject(:json_response) { client.backups.list(app_id) }
    context 'server returns 200' do
      it 'returns the backups available for the app' do
        backups = json_response.select { |backup| backup[:from_type] == 'pg_dump' && backup[:to_type] == 'gof3r' }
        restores = json_response.select { |backup| backup[:from_type] != 'pg_dump' && backup[:to_type] == 'pg_restore' }
        copies = json_response.select { |backup| backup[:from_type] == 'pg_dump' && backup[:to_type] == 'pg_restore' }
        expect(json_response.length).to be > 0
        expect(backups.length).to be > 0
        expect(restores.length).to eq 0
        expect(copies.length).to be > 0
      end
    end
  end

  describe '#schedules' do
    let(:database_id) { ENV['VALID_DATABASE_ID_WITH_SCHEDULES'] }
    subject(:json_response) { client.backups.schedules(database_id) }
    context 'server returns 404' do
      let(:oauth_token) { 'invalid_key' }
      it 'returns an error in json format' do
        expect(json_response[:error][:status]).to eq 404
      end
    end

    context 'server returns 200' do
      it 'returns the backups schedules of a database' do
        expect(json_response.length).to eq 1
        schedule = json_response[0]
        expect(schedule[:uuid]).not_to be_nil
        expect(schedule[:name]).to eq 'DATABASE_URL'
        expect(schedule[:hour]).not_to be_nil
        expect(schedule[:days]).to be_a Array
        expect(schedule[:timezone]).not_to be_nil
        expect(schedule[:created_at]).not_to be_nil
        expect(schedule[:updated_at]).not_to be_nil
        expect(schedule[:deleted_at]).to be_nil
        expect(schedule[:retain_weeks]).to eq 1
        expect(schedule[:retain_months]).to eq 0
      end
    end
  end
end
