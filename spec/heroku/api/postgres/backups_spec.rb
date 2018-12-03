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
    let(:app_id) { ENV['VALID_APP_ID'] }
    let(:database_id) { ENV['VALID_DATABASE_ID_WITH_SCHEDULES'] }
    subject(:json_response) { client.backups.schedules(app_id, database_id) }
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

  describe '#capture' do
    let(:app_id) { ENV['VALID_APP_ID'] }
    let(:database_id) { ENV['VALID_DATABASE_ID_WITH_SCHEDULES'] }
    subject(:json_response) { client.backups.capture(app_id, database_id) }
    context 'server returns 200' do
      it 'captures a backup of the database' do
        expect(json_response[:uuid]).not_to be_nil
        expect(json_response[:from_type]).to eq 'pg_dump'
        expect(json_response[:to_type]).to eq 'gof3r'
        expect(json_response[:succeeded]).to be_nil
      end
    end
  end

  describe '#schedule' do
    let(:app_id) { ENV['VALID_APP_ID'] }
    let(:database_id) { ENV['VALID_DATABASE_ID_WITH_SCHEDULES'] }
    subject(:json_response) { client.backups.schedule(app_id, database_id) }
    context 'server returns 200' do
      it 'creates a schedule for the given database' do
        expect(json_response[:uuid]).not_to be_nil
        expect(json_response[:name]).to eq 'DATABASE_URL'
        expect(json_response[:hour]).to eq 0
        expect(json_response[:timezone]).to eq 'UTC'
      end
    end
  end

  describe '#url' do
    let(:app_id) { ENV['VALID_APP_ID'] }
    let(:backup_num) do
      client.backups.list(app_id).select do |backup|
        backup[:from_type] == 'pg_dump' && backup[:to_type] == 'gof3r'
      end.first[:num]
    end
    subject(:json_response) { client.backups.url(app_id, backup_num) }
    context 'server returns 200' do
      it 'returns the public url of a database' do
        expect(json_response[:expires_at]).not_to be_nil
        expect(json_response[:url]).not_to be_nil
      end
    end
  end

  describe '#info' do
    let(:app_id) { ENV['VALID_APP_ID'] }
    let(:backup) do
      client.backups.list(app_id).select do |backup|
        backup[:from_type] == 'pg_dump' && backup[:to_type] == 'gof3r'
      end.first
    end

    # can be called with num or id
    subject(:json_response) { client.backups.info(app_id, backup[:num]) }

    context 'server returns 200' do
      it 'returns a backup' do
        expect(json_response[:uuid]).not_to be_nil
        expect(json_response[:from_type]).to eq 'pg_dump'
        expect(json_response[:to_type]).to eq 'gof3r'
      end
    end
  end

  describe '#wait' do
    let(:app_id) {ENV['VALID_APP_ID_WITH_DATABASE'] }
    let(:database_id) { ENV['VALID_DATABASE_ID_WITH_SCHEDULES'] }

    context 'server returns 200' do
      it 'waits for the given backup to be available and returns the backup' do
        backup = client.backups.capture(app_id, database_id)
        backup = client.backups.wait(app_id, backup[:num], wait_interval: 0.01)

        expect(backup[:uuid]).not_to be_nil
        expect(backup[:finished_at]).not_to be_nil
        expect(backup[:succeeded]).to eq true
      end
    end
  end

  describe '#restore' do
    let(:app_id) {ENV['VALID_APP_ID_WITH_DATABASE'] }
    let(:database_id) { ENV['VALID_DATABASE_ID_WITH_SCHEDULES'] }
    let(:dump_url) { ENV['VALID_DUMP_URL'] }

    context 'server returns 200' do
      it 'restores a backup from a public url' do
        restore = client.backups.restore(database_id, dump_url)

        expect(restore[:uuid]).not_to be_nil
        expect(restore[:from_name]).to eq 'BACKUP'
        expect(restore[:from_type]).to eq 'htcat'
        expect(restore[:from_url]).to eq dump_url
        expect(restore[:to_name]).to eq 'DATABASE'
        expect(restore[:to_type]).to eq 'pg_restore'
        expect(restore[:succeeded]).to be_nil

        called = false
        restore = client.backups.wait(app_id, restore[:num], wait_interval: 0.01) do |info|
          called = true
        end

        expect(called).to be true
        expect(restore[:finished_at]).not_to be_nil
        expect(restore[:succeeded]).to eq true
      end
    end
  end
end
