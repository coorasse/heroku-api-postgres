require 'net/http'
require 'json'

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

        def schedules(database_id)
          @client.perform_get_request("/client/v11/databases/#{database_id}/transfer-schedules")
        end

        def schedule(database_id)
          @client.perform_post_request("/client/v11/databases/#{database_id}/transfer-schedules",
                                       hour: 00,
                                       timezone: 'UTC',
                                       schedule_name: 'DATABASE_URL')
        end

        def capture(database_id)
          @client.perform_post_request("/client/v11/databases/#{database_id}/backups")
        end

        def url(app_id, backup_num)
          @client.perform_post_request("/client/v11/apps/#{app_id}/transfers/#{backup_num}/actions/public-url")
        end

        def wait(app_id, backup_id, options = { wait_interval: 3 })
          while true do
            backup = info(app_id, backup_id)
            yield(backup)
            break if backup[:finished_at] && backup[:succeeded]
            sleep(options[:wait_interval])
          end
          backup
        end

        def restore(database_id, backup_url)
          @client.perform_post_request("/client/v11/databases/#{database_id}/restores", backup_url: backup_url)
        end
      end
    end
  end
end
