require 'net/http'
require 'json'
require 'platform-api'

module Heroku
  module Api
    module Postgres
      class Backups
        def initialize(client)
          @client = client
        end

        # backups:  from_type == 'pg_dump' && to_type == 'gof3r'
        # restores: from_type != 'pg_dump' && to_type == 'pg_restore'
        # copies:   from_type == 'pg_dump' && to_type == 'pg_restore'
        def list(app_id)
          @client.perform_get_request("/client/v11/apps/#{app_id}/transfers")
        end

        def info(app_id, backup_id)
          @client.perform_get_request("/client/v11/apps/#{app_id}/transfers/#{backup_id}")
        end

        def schedules(app_id, database_id)
          @client.perform_get_request("/client/v11/databases/#{database_id}/transfer-schedules",
                                      host: db_host(app_id))
        end

        def schedule(app_id, database_id)
          @client.perform_post_request("/client/v11/databases/#{database_id}/transfer-schedules",
                                       { hour: 0o0,
                                         timezone: 'UTC',
                                         schedule_name: 'DATABASE_URL' }, host: db_host(app_id))
        end

        def capture(app_id, database_id)
          @client.perform_post_request("/client/v11/databases/#{database_id}/backups", {}, host: db_host(app_id))
        end

        def url(app_id, backup_num)
          @client.perform_post_request("/client/v11/apps/#{app_id}/transfers/#{backup_num}/actions/public-url")
        end

        def wait(app_id, backup_id, options = { wait_interval: 3 })
          backup = nil
          loop do
            backup = info(app_id, backup_id)
            yield(backup) if block_given?
            break if backup[:finished_at] && backup[:succeeded]

            sleep(options[:wait_interval])
          end
          backup
        end

        def restore(database_id, backup_url)
          @client.perform_post_request("/client/v11/databases/#{database_id}/restores", backup_url: backup_url)
        end

        private

        def databases
          @databases ||= Databases.new(@client)
        end

        def db_host(app_id)
          database = heroku_client.addon.list_by_app(app_id).find do |addon|
            addon['addon_service']['name'] == 'heroku-postgresql'
          end
          databases.host_for(database)
        end

        def heroku_client
          @heroku_client ||= PlatformAPI.connect_oauth(@client.oauth_client_key)
        end
      end
    end
  end
end
