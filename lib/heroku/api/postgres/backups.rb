# frozen_string_literal: true

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
                                      host: db_host(app_id, database_id))
        end

        def schedule(app_id, database_id)
          @client.perform_post_request("/client/v11/databases/#{database_id}/transfer-schedules",
                                       { hour: 0o0,
                                         timezone: 'UTC',
                                         schedule_name: 'DATABASE_URL' }, host: db_host(app_id, database_id))
        end

        def capture(app_id, database_id)
          @client.perform_post_request("/client/v11/databases/#{database_id}/backups",
                                       {},
                                       host: db_host(app_id, database_id))
        end

        def url(app_id, backup_num = nil)
          unless backup_num
            transfers = list(app_id)
            last_transfer =
              transfers.select { |t| t[:succeeded] && t[:to_type] == 'gof3r' }
                       .max_by { |t| t[:created_at] }
            backup_num = last_transfer[:num]
          end
          @client.perform_post_request("/client/v11/apps/#{app_id}/transfers/#{backup_num}/actions/public-url")
        end

        def wait(app_id, backup_id, options = { wait_interval: 3 })
          backup = nil
          loop do
            backup = info(app_id, backup_id)
            yield(backup) if block_given?
            break if backup[:finished_at]

            sleep(options[:wait_interval])
          end
          backup
        end

        def restore(app_id, database_id, backup_url)
          @client.perform_post_request("/client/v11/databases/#{database_id}/restores",
                                       { backup_url: backup_url }, host: db_host(app_id, database_id))
        end

        private

        def db_host(app_id, database_id)
          @client.db_host(app_id, database_id)
        end
      end
    end
  end
end
